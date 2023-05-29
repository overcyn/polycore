//
//  Tasks.swift
//  GitApp
//
//  Created by Kevin Dang on 10/5/19.
//  Copyright © 2019 Overcyn. All rights reserved.
//

import Foundation

public typealias ProgressFunc = ((Progress) -> Void)

public typealias CancelFunc = () -> ()
public class CancelHandler {
    private var _cancelled: Bool = false
    
    public init() {}
    
    public var isCancelled: Bool {
        return _cancelled
    }
    
    public func cancel() {
        _cancelled = true
    }
}

public struct Progress: Equatable {
    public var percentage: Float?
    public var description: String?
    
    public init(percentage: Float? = nil, description: String? = nil) {
        self.percentage = percentage
        self.description = description
    }
    
    public static func ==(lhs: Progress, rhs: Progress) -> Bool {
        let equal = ((lhs.percentage == nil) == (rhs.percentage == nil)) && ((lhs.percentage ?? 0) * 1000).rounded() == ((rhs.percentage ?? 0) * 1000).rounded() && lhs.description == rhs.description
        return equal
    }
    
    public static func wrap(progress: ProgressFunc?, start: Float, end: Float) -> ProgressFunc {
        let s = max(min(start, 1), 0)
        let e = max(min(end, 1), s)
        return { p in
            let percentage = max(min((p.percentage ?? 0), 1), 0)
            progress?(Progress(percentage: s + percentage * (e - s), description: p.description))
        }
    }
}

public class TaskQueue {
    public static var shared: TaskQueue = TaskQueue()
    let runQueue = DispatchQueue(label: "TaskQueue")
    private var stopped = false
    
    public init() {
        NotificationCenter.default.addObserver(self, selector: #selector(willTerminate), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    @discardableResult
    public func run<T: Task, R>(_ task: T) throws -> R where T.TaskResult == R {
        var result: Result<R, Error>?
        runQueue.sync {
            if self.stopped {
                result = .failure(StringError("Repository has been closed"))
            } else {
                let backgroundTaskId = UIApplication.shared.beginBackgroundTask()
                do {
                    let rlt = try task.run(progress: nil, cancel: CancelHandler())
                    result = .success(rlt)
                } catch {
                    result = .failure(error)
                }
                UIApplication.shared.endBackgroundTask(backgroundTaskId)
            }
        }
        return try result!.get()
    }
    
    public func add<T: Task, R>(_ task: T, progress: ProgressFunc?, completion: ((Result<R, Error>) -> Void)?) -> CancelFunc where T.TaskResult == R {
        let cancelHandler = CancelHandler()
        runQueue.async {
            guard !cancelHandler.isCancelled else {
                return
            }
            
            let result: Result<R, Error>
            if self.stopped {
                result = .failure(StringError("Repository has been closed"))
            } else {
                let backgroundTaskId = UIApplication.shared.beginBackgroundTask()
                do {
                    let rlt = try task.run(progress: { p in
                        DispatchQueue.main.async {
                            progress?(p)
                        }
                    }, cancel: cancelHandler)
                    result = .success(rlt)
                } catch {
                    result = .failure(error)
                }
                UIApplication.shared.endBackgroundTask(backgroundTaskId)
            }
            
            DispatchQueue.main.async {
                if !cancelHandler.isCancelled {
                    completion?(result)
                }
            }
        }
        return {
            cancelHandler.cancel()
        }
    }
    
    public func stop() {
        runQueue.async {
            self.stopped = true
        }
    }
    
    @objc func willTerminate() {
        runQueue.suspend()
    }
}

public protocol Task {
    associatedtype TaskResult
    func run(progress: ProgressFunc?, cancel: CancelHandler) throws -> TaskResult
}

public protocol AsyncTask {
    associatedtype TaskResult
    func run(progress: ProgressFunc?, cancel: CancelHandler, completion: @escaping (Result<TaskResult, Error>) -> ())
}

public class ConcurrentTaskQueue {
    public static var shared: ConcurrentTaskQueue = ConcurrentTaskQueue(background: false)
    public static var background: ConcurrentTaskQueue = ConcurrentTaskQueue(background: true)
    public let background: Bool
    
    public init(background: Bool) {
        self.background = background
    }
    
    @discardableResult
    public func addAsync<T: AsyncTask, R>(_ asyncTask: T, progress: ProgressFunc?, completion: ((Result<R, Error>) -> Void)?) -> CancelFunc where T.TaskResult == R {
        var progressWrapper: ProgressFunc? = nil
        if let progress = progress {
            progressWrapper = { p in
                DispatchQueue.main.async(execute: {
                    progress(p)
                })
            }
        }
        
        let cancelHandler = CancelHandler()
        let backgroundTaskId = UIApplication.shared.beginBackgroundTask()
        if background {
            DispatchQueue.global(qos: .default).async {
                asyncTask.run(progress: progressWrapper, cancel: cancelHandler, completion: { result in
                    DispatchQueue.main.async(execute: {
                        completion?(result)
                        UIApplication.shared.endBackgroundTask(backgroundTaskId)
                    })
                })
            }
        } else {
            asyncTask.run(progress: progressWrapper, cancel: cancelHandler, completion: { result in
                DispatchQueue.main.async(execute: {
                    completion?(result)
                    UIApplication.shared.endBackgroundTask(backgroundTaskId)
                })
            })
        }
        return {
            cancelHandler.cancel()
        }
    }
}

public struct BlockTask: Task {
    public typealias TaskResult = Void
    public let block: ()->()
    
    public init(_ block: @escaping (()->())) {
        self.block = block
    }
    
    public func run(progress: ProgressFunc?, cancel: CancelHandler) throws -> Void {
        block()
    }
}

public struct AsyncBlockTask: AsyncTask {
    public typealias TaskResult = Void
    public let block: ((Result<TaskResult, Error>) -> ())->()
    
    public init(_ block: @escaping ((Result<TaskResult, Error>) -> ())->()) {
        self.block = block
    }
    
    public func run(progress: ProgressFunc?, cancel: CancelHandler, completion: @escaping (Result<TaskResult, Error>) -> ()) {
        block(completion)
    }
}

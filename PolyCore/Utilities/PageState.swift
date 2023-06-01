//
//  State.swift
//  GitApp
//
//  Created by Kevin Dang on 12/31/19.
//  Copyright © 2019 Overcyn. All rights reserved.
//

import Foundation

public class LoadController {
    public init() {}
    
    public var needsLoad: Bool = true {
        didSet {
            loadIfNeeded()
        }
    }
    public var isVisible: Bool = false {
        didSet {
            loadIfNeeded()
        }
    }
    public var loadFunc: () -> () = {}
    
    private func loadIfNeeded() {
        if needsLoad && isVisible {
            needsLoad = false
            loadFunc()
        }
    }
}

public class LoadController2 {
    public init() {}
    
    public var needsLoad: Bool = true {
        didSet {
            loadIfNeeded()
        }
    }
    public var isVisible1: Bool = false {
        didSet {
            loadIfNeeded()
        }
    }
    public var isVisible2: Bool = false {
        didSet {
            loadIfNeeded()
        }
    }
    public var loadFunc: () -> () = {}
    
    private func loadIfNeeded() {
        if needsLoad && (isVisible1 || isVisible2) {
            needsLoad = false
            loadFunc()
        }
    }
}

public enum LoadState<T> {
    case initial
    case loading(CancelFunc)
    case failure(Error)
    case successAndLoading(T, CancelFunc)
    case success(T)
    
    public var isSuccessful: Bool {
        switch self {
        case .success, .successAndLoading:
            return true
        default:
            return false
        }
    }
    
    public var model: T? {
        switch self {
        case .successAndLoading(let model, _), .success(let model):
            return model
        default:
            return nil
        }
    }
    
    public mutating func load(resets: Bool = false, _ success: () -> (CancelFunc)) -> Bool {
        switch self {
        case .initial, .failure:
            let cancelFunc = success()
            self = .loading(cancelFunc)
            return true
        case .loading(let prevCancelFunc):
            prevCancelFunc()
            let cancelFunc = success()
            self = .loading(cancelFunc)
            return true
        case .successAndLoading(let model, let prevCancelFunc):
            prevCancelFunc()
            let cancelFunc = success()
            if resets {
                self = .loading(cancelFunc)
            } else {
                self = .successAndLoading(model, cancelFunc)
            }
            return true
        case .success(let model):
            let cancelFunc = success()
            if resets {
                self = .loading(cancelFunc)
            } else {
                self = .successAndLoading(model, cancelFunc)
            }
            return true
        }
    }
    
    public mutating func loadMore(_ success: (T) -> (CancelFunc)) -> Bool {
        switch self {
        case .success(let model):
            let cancelFunc = success(model)
            self = .successAndLoading(model, cancelFunc)
            return true
        default:
            return false
        }
    }
    
    public mutating func loadComplete(_ result: Result<T, Error>) -> Bool {
        switch self {
        case .loading, .successAndLoading:
            break
        default:
            return false
        }
        switch result {
        case .success(let model):
            self = .success(model)
        case .failure(let error):
            self = .failure(error)
        }
        return true
    }
    
    public mutating func reset() -> Bool {
        switch self {
        case .loading(let cancelFunc), .successAndLoading(_, let cancelFunc):
            cancelFunc()
        default:
            break
        }
        self = .initial
        return true
    }
}

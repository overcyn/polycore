//
//  Debouncer.swift
//  GitApp
//
//  Created by Kevin Dang on 3/22/20.
//  Copyright © 2020 Overcyn. All rights reserved.
//

import Foundation

public class Debouncer {
    public var callback: (() -> ()) = {}
    public var delay: Double = 1.0
    weak var timer: Timer? = nil
    
    public init() {}

    public func call() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(Debouncer.fireNow), userInfo: nil, repeats: false)
    }

    @objc func fireNow() {
        self.callback()
    }
}

public class Throttler {
    public var callback: (() -> ()) = {} // Callback occurs on main thread
    public var delay: Double = 1.0
    
    var lock: NSLock = NSLock()
    var timer: DispatchSourceTimer? = nil
    
    public init() {}

    deinit {
        lock.lock()
        if let timer = timer {
            timer.setEventHandler(handler: nil)
            timer.cancel()
        }
        lock.unlock()
    }
    
    public func call() {
        lock.lock()
        if timer == nil {
            timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
            timer?.setEventHandler(handler: { [weak self] in
                self?.fireNow()
            })
            timer?.schedule(deadline: .now() + TimeInterval(delay))
            timer?.resume()
        }
        lock.unlock()
    }

    public func fireNow() {
        lock.lock()
        timer = nil
        lock.unlock()
        
        callback()
    }
}

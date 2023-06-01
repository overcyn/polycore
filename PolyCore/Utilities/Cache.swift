//
//  StateCache.swift
//  PolyGit
//
//  Created by Kevin Dang on 6/19/20.
//  Copyright © 2020 Overcyn. All rights reserved.
//

import Foundation

public class WeakCacheObserver {
    private(set) weak var value: CacheObserver?
    public init(_ value: CacheObserver?) {
        self.value = value
    }
}

public protocol CacheObserver: AnyObject {
    func cacheOnUpdate(name: String)
    func cacheOnNeedsUpdate(name: String)
}

public class Cache<T> {
    public let name: String
    public var observers: [WeakCacheObserver] = []
    
    // Protected by lock
    public let lock: NSLock = NSLock()
    public var value: Result<T, Error>
    public var needsUpdate: Bool = true
    public var updating: Bool = false
    
    public init(name: String, initialValue: T) {
        self.name = name
        self.value = .success(initialValue)
    }
    
    public func getValue() throws -> T {
        lock.lock()
        let v = value
        lock.unlock()
        return try v.get()
    }

    public func update(_ updateFunc: (Result<T, Error>) throws -> (T)) {
        lock.lock()
        if needsUpdate {
            needsUpdate = false
            updating = true
            let v = value
            lock.unlock()
            
            let result = Result(catching: {
                return try updateFunc(v)
            })
            
            lock.lock()
            value = result
            updating = false
            lock.unlock()
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                for i in self.observers {
                    i.value?.cacheOnUpdate(name: self.name)
                }
            }
        } else {
            lock.unlock()
        }
    }
    
    public func setNeedsUpdate() {
        lock.lock()
        if !needsUpdate {
            needsUpdate = true
            lock.unlock()
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                for i in self.observers {
                    i.value?.cacheOnNeedsUpdate(name: self.name)
                }
            }
        } else {
            lock.unlock()
        }
    }
}

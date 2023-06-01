//
//  CacheTests.swift
//  PolyGit
//
//  Created by Kevin Dang on 6/20/20.
//  Copyright © 2020 Overcyn. All rights reserved.
//

import XCTest
@testable import PolyGit
@testable import PolyCore

class CacheObserverImpl: CacheObserver {
    var cacheOnUpdateFunc: ((String) -> ())?
    func cacheOnUpdate(name: String) {
        cacheOnUpdateFunc?(name)
    }
    
    var cacheOnNeedsUpdateFunc: ((String) -> ())?
    func cacheOnNeedsUpdate(name: String) {
        cacheOnNeedsUpdateFunc?(name)
    }
}

class Cache_Tests: XCTestCase {
    func testInitialize() throws {
        let cache = Cache<Int>(name: "test", initialValue: 5)
        let value = try cache.getValue()
        XCTAssert(cache.name == "test" && value == 5)
    }
    
    func testUpdate() throws {
        let cache = Cache<Int>(name: "test", initialValue: 5)
        
        cache.update({ v in
            try! XCTAssert(v.get() == 5)
            return 3
        })
        let value = try cache.getValue()
        XCTAssert(cache.name == "test" && value == 3)
    }
    
    func testUpdateAndThrows() throws {
        let cache = Cache<Int>(name: "test", initialValue: 5)
        
        cache.update({ v in
            try! XCTAssert(v.get() == 5)
            throw StringError("Poop")
        })
        do {
            _ = try cache.getValue()
            XCTFail()
        } catch {
        }
    }
    
    func testUpdateAndNoChanges() throws {
        let cache = Cache<Int>(name: "test", initialValue: 5)
        
        cache.update({ v in
            try! XCTAssert(v.get() == 5)
            return 3
        })
        cache.update({ v in
            try! XCTAssert(v.get() == 3)
            return 7
        })
        let value = try cache.getValue()
        XCTAssert(cache.name == "test" && value == 3)
    }
    
    func testUpdateAndNotify() throws {
        let cache = Cache<Int>(name: "test", initialValue: 5)

        let exp = expectation(description: "")
        let observer = CacheObserverImpl()
        observer.cacheOnUpdateFunc = { name in
            exp.fulfill()
        }
        cache.observers.append(WeakCacheObserver(observer))

        let exp2 = expectation(description: "")
        let observer2 = CacheObserverImpl()
        observer2.cacheOnUpdateFunc = { name in
            exp2.fulfill()
        }
        cache.observers.append(WeakCacheObserver(observer2))

        cache.update({ v in
            try! XCTAssert(v.get() == 5)
            return 3
        })
        waitForExpectations(timeout: 10)
    }
    
    func testSetNeedsUpdate() throws {
        let cache = Cache<Int>(name: "test", initialValue: 5)
        
        cache.update({ v in
            try! XCTAssert(v.get() == 5)
            return 3
        })
        cache.update({ v in
            try! XCTAssert(v.get() == 3)
            return 7
        })
        let value = try cache.getValue()
        XCTAssert(cache.name == "test" && value == 3)
        
        cache.setNeedsUpdate()
        cache.update({ v in
            try! XCTAssert(v.get() == 3)
            return 7
        })
        let value2 = try cache.getValue()
        XCTAssert(cache.name == "test" && value2 == 7)
    }
    
    func testSetNeedsUpdateAndNotify() throws {
        let cache = Cache<Int>(name: "test", initialValue: 5)

        cache.update({ v in
            try! XCTAssert(v.get() == 5)
            return 3
        })

        let exp = expectation(description: "")
        let observer = CacheObserverImpl()
        observer.cacheOnNeedsUpdateFunc = { name in
            exp.fulfill()
        }
        cache.observers.append(WeakCacheObserver(observer))

        let exp2 = expectation(description: "")
        let observer2 = CacheObserverImpl()
        observer2.cacheOnNeedsUpdateFunc = { name in
            exp2.fulfill()
        }
        cache.observers.append(WeakCacheObserver(observer2))

        cache.setNeedsUpdate()
        waitForExpectations(timeout: 10)
    }
}


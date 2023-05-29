//
//  Tasks_Tests.swift
//  PolyGitTests
//
//  Created by Kevin Dang on 1/2/21.
//  Copyright © 2021 Overcyn. All rights reserved.
//

import XCTest
@testable import PolyCore

class TaskQueue_Tests: XCTestCase {
    func testRun() throws {
        let taskQueue = TaskQueue()
        let expectation = XCTestExpectation()
        DispatchQueue.global().async {
            do {
                try taskQueue.run(BlockTask({
                    expectation.fulfill()
                }))
            } catch {
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testAdd() throws {
        let taskQueue = TaskQueue()
        let expectation = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        DispatchQueue.global().async {
            _ = taskQueue.add(BlockTask({
                expectation2.fulfill()
            }), progress: nil, completion: { result in
                switch result {
                case .failure:
                    XCTFail()
                case .success:
                    expectation.fulfill()
                }
            })
        }
        wait(for: [expectation, expectation2], timeout: 10.0)
    }
    
    func testRunCancelled() throws {
        let taskQueue = TaskQueue()
        taskQueue.stop()
        let expectation = XCTestExpectation()
        DispatchQueue.global().async {
            do {
                try taskQueue.run(BlockTask({
                    XCTFail()
                }))
            } catch {
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testAddCancelled() throws {
        let taskQueue = TaskQueue()
        taskQueue.stop()
        let expectation = XCTestExpectation()
        DispatchQueue.global().async {
            _ = taskQueue.add(BlockTask({
                XCTFail()
            }), progress: nil, completion: { result in
                switch result {
                case .failure:
                    expectation.fulfill()
                case .success:
                    XCTFail()
                }
            })
        }
        wait(for: [expectation], timeout: 10.0)
    }
}

class ConcurrentTaskQueue_Tests: XCTestCase {
    func testAddAsync() throws {
        let taskQueue = ConcurrentTaskQueue(background: false)
        let expectation = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        _ = taskQueue.addAsync(AsyncBlockTask({ completion in
            XCTAssert(Thread.isMainThread)
            expectation2.fulfill()
            completion(.success(()))
        }), progress: nil, completion: { result in
            XCTAssert(Thread.isMainThread)
            switch result {
            case .failure:
                XCTFail()
            case .success:
                expectation.fulfill()
            }
        })
        wait(for: [expectation, expectation2], timeout: 10.0)
    }
    
    func testBackgroundAddAsync() throws {
        let taskQueue = ConcurrentTaskQueue(background: true)
        let expectation = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        _ = taskQueue.addAsync(AsyncBlockTask({ completion in
            XCTAssert(!Thread.isMainThread)
            expectation2.fulfill()
            completion(.success(()))
        }), progress: nil, completion: { result in
            XCTAssert(Thread.isMainThread)
            switch result {
            case .failure:
                XCTFail()
            case .success:
                expectation.fulfill()
            }
        })
        wait(for: [expectation, expectation2], timeout: 10.0)
    }
}

//
//  Debouncer_Tests.swift
//  PolyGitTests
//
//  Created by Kevin Dang on 4/15/21.
//  Copyright © 2021 Overcyn. All rights reserved.
//

import XCTest
@testable import PolyGit
@testable import PolyCore

class Throttler_Tests: XCTestCase {
    func test() throws {
        let expectation = XCTestExpectation()
        expectation.assertForOverFulfill = true
        let throttler = Throttler()
        throttler.callback = {
            XCTAssert(Thread.isMainThread)
            expectation.fulfill()
        }
        throttler.call()
        throttler.call()
        throttler.call()
        throttler.call()
        throttler.call()
        throttler.call()
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testBackground() throws {
        let expectation = XCTestExpectation()
        expectation.assertForOverFulfill = true
        var throttler: Throttler? = nil
        DispatchQueue.global().async(execute: {
            throttler = Throttler()
            throttler?.callback = {
                XCTAssert(Thread.isMainThread)
                expectation.fulfill()
            }
            throttler?.call()
            throttler?.call()
            throttler?.call()
            throttler?.call()
            throttler?.call()
            throttler?.call()
        })
        wait(for: [expectation], timeout: 10.0)
    }
}

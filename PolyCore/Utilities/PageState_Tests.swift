//
//  PageState_Tests.swift
//  PolyGitTests
//
//  Created by Kevin Dang on 7/12/20.
//  Copyright © 2020 Overcyn. All rights reserved.
//

import XCTest
@testable import PolyGit
@testable import PolyCore

class LoadController_Tests: XCTestCase {
    func testBasic() throws {
        var loadCount: Int = 0
        let loadController = LoadController()
        loadController.loadFunc = {
            loadCount += 1
        }
        loadController.isVisible = true
        XCTAssert(loadCount == 1)
        
        loadController.isVisible = true
        loadController.isVisible = false
        XCTAssert(loadCount == 1)
        
        loadController.isVisible = true
        loadController.needsLoad = true
        loadController.needsLoad = true
        loadController.needsLoad = true
        loadController.isVisible = false
        XCTAssert(loadCount == 4)
        
        loadController.needsLoad = true
        loadController.needsLoad = true
        loadController.needsLoad = true
        XCTAssert(loadCount == 4)
        
        loadController.isVisible = true
        XCTAssert(loadCount == 5)
    }
}

class LoadController2_Tests: XCTestCase {
    func testBasic() throws {
        var loadCount: Int = 0
        let loadController = LoadController2()
        loadController.loadFunc = {
            loadCount += 1
        }
        loadController.isVisible1 = true
        XCTAssert(loadCount == 1)
        
        loadController.isVisible1 = true
        loadController.isVisible1 = false
        XCTAssert(loadCount == 1)
        
        loadController.isVisible1 = true
        loadController.needsLoad = true
        loadController.needsLoad = true
        loadController.needsLoad = true
        loadController.isVisible1 = false
        XCTAssert(loadCount == 4)
        
        loadController.needsLoad = true
        loadController.needsLoad = true
        loadController.needsLoad = true
        XCTAssert(loadCount == 4)
        
        loadController.isVisible1 = true
        XCTAssert(loadCount == 5)
        loadController.isVisible1 = false
        
        loadController.needsLoad = true
        loadController.isVisible2 = true
        XCTAssert(loadCount == 6)
        
        loadController.isVisible2 = true
        loadController.isVisible2 = false
        XCTAssert(loadCount == 6)
        
        loadController.isVisible2 = true
        loadController.needsLoad = true
        loadController.needsLoad = true
        loadController.needsLoad = true
        loadController.isVisible2 = false
        XCTAssert(loadCount == 9)
        
        loadController.needsLoad = true
        loadController.needsLoad = true
        loadController.needsLoad = true
        XCTAssert(loadCount == 9)
        
        loadController.isVisible2 = true
        XCTAssert(loadCount == 10)
    }
    
    func testInterleaved() throws {
        var loadCount: Int = 0
        let loadController = LoadController2()
        loadController.loadFunc = {
            loadCount += 1
        }
        loadController.isVisible1 = true
        XCTAssert(loadCount == 1)
        
        loadController.isVisible2 = true
        loadController.needsLoad = true
        XCTAssert(loadCount == 2)
        
        loadController.isVisible1 = false
        loadController.isVisible2 = false
        loadController.needsLoad = true
        XCTAssert(loadCount == 2)
        
        loadController.isVisible2 = true
        XCTAssert(loadCount == 3)
        
        loadController.needsLoad = true
        loadController.needsLoad = true
        XCTAssert(loadCount == 5)
        
    }
}

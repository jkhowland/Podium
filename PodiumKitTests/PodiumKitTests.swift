//
//  PodiumKitTests.swift
//  PodiumKitTests
//
//  Created by Joshua Howland on 6/9/15.
//  Copyright (c) 2015 [insert name here]. All rights reserved.
//

import UIKit
import XCTest

class PodiumKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()

        Stack.defaultStack.clearAllData()
        Stack.defaultStack.loadFakeData()

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testProfileCount() {
        let profileCount = ProfileController.sharedController.allProfiles()
        XCTAssert(profileCount.count == 10)
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}

//
//  ProfileTestCase.swift
//  Podium
//
//  Created by Joshua Howland on 6/10/15.
//  Copyright © 2015 [insert name here]. All rights reserved.
//

import UIKit
import XCTest
import PodiumKit

class ProfileTestCase: XCTestCase {

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
        XCTAssert(profileCount!.count == 10)
    }

}

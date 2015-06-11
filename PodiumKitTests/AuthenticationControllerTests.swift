//
//  AuthenticationControllerTests.swift
//  Podium
//
//  Created by Tim Shadel on 6/10/15.
//  Copyright © 2015 [insert name here]. All rights reserved.
//

import UIKit
import XCTest
import PodiumKit

class AuthenticationControllerTests: XCTestCase {

    override func setUp() {
        super.setUp()

        Stack.defaultStack.clearAllData()
        Stack.defaultStack.loadFakeData()

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    

    func testSuccessfulRegistration() {
        let profile = AuthenticationController.sharedController.signUp("Bob Jones", email: "bob@jones.com", phone: "801-449-9494")
    }
}
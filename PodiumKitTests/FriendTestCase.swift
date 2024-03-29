//
//  FriendTestCase.swift
//  Podium
//
//  Created by Joshua Howland on 6/10/15.
//  Copyright © 2015 [insert name here]. All rights reserved.
//

import UIKit
import XCTest
import PodiumKit

class FriendTestCase: XCTestCase {

    override func setUp() {
        super.setUp()

        Stack.defaultStack.clearAllData()
        Stack.defaultStack.loadFakeData()
        
    }
    
    override func tearDown() {
        super.tearDown()
        
        Stack.defaultStack.clearAllData()
    }

    func testFriendCount() {
        let friendCount = FriendController.sharedController.allFriends()
        XCTAssert(friendCount!.count == 30)
    }

    func testJoshFriends() {
        XCTAssert(self.testFriendCount(joshEmail, count: 4))
    }
    
    func testAshleyFriends() {
        XCTAssert(self.testFriendCount(ashleyEmail, count: 4))
    }

    func testBenFriendProfiles() {
        XCTAssert(self.testFriendProfileCount(benEmail, count: 2))
    }
    
    func testAshleyFriendProfiles() {
        XCTAssert(self.testFriendProfileCount(ashleyEmail, count: 4))
    }
    
    
    func testFriendCount(email: String, count: Int) -> Bool {
    
        AuthenticationController.sharedController.currentProfile = ProfileController.sharedController.findProfileUsingEmail(email)!
        
        FriendController.sharedController.resetFriends()
        let friends = FriendController.sharedController.friends
        return(friends.count == count)
    }
    
    func testFriendProfileCount(email: String, count: Int) -> Bool {
     
        AuthenticationController.sharedController.currentProfile = ProfileController.sharedController.findProfileUsingEmail(email)!
        
        FriendController.sharedController.resetFriends()
        let friends = FriendController.sharedController.friendProfiles()
        return(friends.count == count)
    }
    
}

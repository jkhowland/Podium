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
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFriendCount() {
        let friendCount = FriendController.sharedController.allFriends()
        XCTAssert(friendCount!.count == 30)
    }

    func testFriendJoshCount() {
        
        AuthenticationController.sharedController.currentProfile = ProfileController.sharedController.findProfileUsingEmail(joshEmail)!

        FriendController.sharedController.updateFriendsCompletionHandler { (complete) -> Void in
            let friends = FriendController.sharedController.friends
            print("Josh has \(friends.count) friends")
            XCTAssert(friends.count == 4)
        }
        
    }

    func testFriendProfileJoshCount() {
        
        AuthenticationController.sharedController.currentProfile = ProfileController.sharedController.findProfileUsingEmail(joshEmail)!
        
        FriendController.sharedController.updateFriendsCompletionHandler { (complete) -> Void in
            let friends = FriendController.sharedController.friendProfiles()
            print("Josh has \(friends.count) friend profiles")
            XCTAssert(friends.count == 4)
        }
        
    }

    
    func testFriendBenCount() {
        
        AuthenticationController.sharedController.currentProfile = ProfileController.sharedController.findProfileUsingEmail(benEmail)!
        
        FriendController.sharedController.updateFriendsCompletionHandler { (complete) -> Void in
            let friends = FriendController.sharedController.friends
            print("Ben has \(friends.count) friends")
            XCTAssert(friends.count == 2)
        }
        
    }
    
    func testFriendProfileBenCount() {
        
        AuthenticationController.sharedController.currentProfile = ProfileController.sharedController.findProfileUsingEmail(joshEmail)!
        
        FriendController.sharedController.updateFriendsCompletionHandler { (complete) -> Void in
            let friends = FriendController.sharedController.friendProfiles()
            print("Josh has \(friends.count) friend profiles")
            XCTAssert(friends.count == 2)
        }
        
    }


    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}

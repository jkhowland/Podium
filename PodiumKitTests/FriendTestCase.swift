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

    func testFriendProfileCount() {
        
        // Fix test to test for correct profile count
        
        let friendCount = FriendController.sharedController.allFriends()

        FriendController.sharedController.updateFriendsCompletionHandler { (complete) -> Void in
            let friends = FriendController.sharedController.friends
            if friends.count > 0 {
                print(friends[0].email)
            }
            
            XCTAssert(friendCount!.count == 30)
        }
        
    }


    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}

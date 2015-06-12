//
//  InviteTestCase.swift
//  Podium
//
//  Created by Joshua Howland on 6/10/15.
//  Copyright © 2015 [insert name here]. All rights reserved.
//

import UIKit
import XCTest
import PodiumKit

class InviteTestCase: XCTestCase {

    override func setUp() {
        super.setUp()

        Stack.defaultStack.clearAllData()
        Stack.defaultStack.loadFakeData()
    }
    
    override func tearDown() {
        super.tearDown()
        
        Stack.defaultStack.clearAllData()
    }

    func testInviteCount() {
        let receivedInvites = InviteController.sharedController.receivedInvites(eddyEmail)
        XCTAssert(receivedInvites.count == 1)
    }
    
    func testInviteAccept() {
        
        AuthenticationController.sharedController.signUp("Eddy Cue", email: eddyEmail, phone: "801-450-3213") { (success, error) -> Void in

            let receivedInvites = InviteController.sharedController.receivedInvites(eddyEmail)
            
            XCTAssert(receivedInvites.count == 0)
            XCTAssert(self.testFriendCount(eddyEmail, count: 1))

        }
    }
    
    func testFriendCount(email: String, count: Int) -> Bool {
        
        FriendController.sharedController.updateFriends()
        let friends = FriendController.sharedController.friends
        return(friends.count == count)
        
    }


}

//
//  FriendController.swift
//  Podium
//
//  Created by Joshua Howland on 6/9/15.
//  Copyright © 2015 [insert name here]. All rights reserved.
//

import UIKit

public enum SortFriends {
    case Alphabetically
    case BySteps
    case ByCalories
    case ByWater
}

public class FriendController: NSObject {
    public static let sharedController = NetworkController()

    var friends: Array<User> = []
    
    public func sortFriends(sort: SortFriends) -> Array<User> {
        return self.friends
    }
    
    // Should probably return array of dictionaries [displayName, email]
    public func findPotentialFriends() -> Array<AnyObject> {

        // Potentially add source as parameter
        // Returns list of users with valid email addresses to invite
        return []
    }
    
    public func requestFriend(userID: Int64) {
    
        // Creates Friend object
        // Sends email/request to user
        
    }
    
    public func acceptFriend(friend: Friend) {
    
        // Marks friend as accepted
        // Creates new reverse Friend object and marks as accepted
        
    }
    
    
}

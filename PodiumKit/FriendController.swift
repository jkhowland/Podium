//
//  FriendController.swift
//  Podium
//
//  Created by Joshua Howland on 6/9/15.
//  Copyright © 2015 [insert name here]. All rights reserved.
//

import UIKit
import CoreData

let FriendEntityName = "Friend"

public enum SortFriends {
    case Alphabetically
    case BySteps
    case ByCalories
    case ByWater
}

public class FriendController: NSObject {
    public static let sharedController = FriendController()

    var friends: Array<Profile> = []
    
    public func sortFriends(sort: SortFriends) -> Array<Profile> {
        return self.friends
    }
    
    // Should probably return array of dictionaries [displayName, email]
    public func findPotentialFriends() -> Array<AnyObject> {

        // Potentially add source as parameter
        // Returns list of users with valid email addresses to invite
        return []
    }
    
    public func requestFriends(fromProfileIdentifier: Int, toProfileIdentifier: Int) -> Friend {
    
        // Creates Friend object

        let friend: Friend = NSEntityDescription.insertNewObjectForEntityForName(FriendEntityName, inManagedObjectContext: Stack.defaultStack.mainContext!) as! Friend
        
        let fromProfile = ProfileController.sharedController.findProfileUsingIdentifier(fromProfileIdentifier)
        let toProfile = ProfileController.sharedController.findProfileUsingIdentifier(toProfileIdentifier)
        
        friend.currentProfile = fromProfile
        friend.profile = toProfile
        friend.accepted = NSNumber(bool: false)
        
        // Send email/request to user
        
        return friend
        
    }
    
    public func requestFriend(userID: Int) -> Friend {

        return self.requestFriends((AuthenticationController.sharedController.currentProfile.identifier?.integerValue)!, toProfileIdentifier: userID)
        
    }
    
    public func acceptFriend(friend: Friend) {
    
        // Marks friend as accepted
        
        friend.accepted = NSNumber(bool: true)
        
        // Creates new reverse Friend object and marks as accepted
        
        let newFriend: Friend = NSEntityDescription.insertNewObjectForEntityForName(FriendEntityName, inManagedObjectContext: Stack.defaultStack.mainContext!) as! Friend

        newFriend.currentProfile = friend.profile
        newFriend.profile = friend.currentProfile
        newFriend.accepted = NSNumber(bool: true)
        
    }
    
}

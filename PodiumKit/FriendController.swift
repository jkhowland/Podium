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

    public var friends: [Friend] = []
    
    public func sortFriends(sort: SortFriends) -> [Friend] {
        return self.friends
    }
    
    public func resetFriends() {
    
        let request = NSFetchRequest(entityName: Friend.entityName)
        let predicate = NSPredicate(format: "currentProfile.identifier = %@ && accepted = %@", AuthenticationController.sharedController.currentProfile!.identifier!, NSNumber(bool: true))
        request.predicate = predicate
        
        var friendObjects: [Friend] = []
        
        do {
            friendObjects = try Stack.defaultStack.mainContext?.executeFetchRequest(request) as! [Friend]
        } catch let error as NSError {
            print(error)
        }
        
        self.friends = friendObjects

    }
    
    public func updateFriends(completionHandler:(success: Bool) -> Void) {
    
        if AuthenticationController.sharedController.currentProfile != nil {
            
            NetworkController.sharedController.fetchRecordsWithType(Friend.entityName, predicate: NSPredicate(value: true)) { (results) -> Void in
                
                for friendDictionary in results {
                    self.findOrAddFriend(friendDictionary)
                }
                
                completionHandler(success: true)
            }
        }
        
        completionHandler(success: false)
        
    }
    
    public func findOrAddFriend(friendDictionary: [String: AnyObject?]) -> Friend? {
    
        if let number = friendDictionary[Friend.identifierKey] as! NSNumber? {
            if let friend = self.findFriendUsingIdentifier(number.integerValue) {
                return friend
            } else {
                if let friend = self.addFriendDictionary(friendDictionary) {
                    return friend
                }
            }
        }
        
        return nil
    }
    
    public func friendProfiles() -> [Profile] {
    
        var friends: [Profile] = []
        for friendObject in self.friends {
            if let profile = friendObject.profile {
                friends.append(profile)
            }
        }
        
        return friends
    }
    
    // Should probably return array of dictionaries [displayName, email]
    public func findPotentialFriends() -> [AnyObject] {

        // Potentially add source as parameter
        // Returns list of users with valid email addresses to invite
        return []
    }
    
    public func friendForProfile(profile: Profile) -> Friend? {
    
        let filteredArray = self.allFriends()!.filter( { (friend: Friend) -> Bool in
            return friend.profile?.identifier?.integerValue == profile.identifier?.integerValue
        })
    
        if filteredArray.count > 0 {
            return filteredArray[0]
        } else {
            return nil
        }
    }
    
    public func requestFriends(fromProfileIdentifier: Int, toProfileIdentifier: Int, completionHandler:(success: Bool, friend: Friend, errorMessage: String) -> Void) {
    
        // Creates Friend object

        let friend: Friend = NSEntityDescription.insertNewObjectForEntityForName(FriendEntityName, inManagedObjectContext: Stack.defaultStack.mainContext!) as! Friend
        
        let fromProfile = ProfileController.sharedController.findProfileUsingIdentifier(fromProfileIdentifier)
        let toProfile = ProfileController.sharedController.findProfileUsingIdentifier(toProfileIdentifier)
        
        friend.currentProfile = fromProfile
        friend.profile = toProfile
        friend.accepted = NSNumber(bool: false)
        friend.identifier = NSNumber(integer: (self.maxIdentifier().integerValue) + 1);
        
        // Send email/request to user
        
        NetworkController.sharedController.postRecord(Friend.entityName, recordDictionary: self.friendDictionary(friend)) { (success, networkIdentifier) -> Void in

            if success {
                Stack.defaultStack.save()
                completionHandler(success: true, friend: friend, errorMessage: "")
            } else {
                Stack.defaultStack.mainContext?.delete(friend)
                completionHandler(success: false, friend: friend, errorMessage: "Failed to send request")
            }
        }
        
    }
    
    public func requestFriend(userID: Int, completionHandler:(success: Bool, friend: Friend, errorMessage: String) -> Void) {

        self.requestFriends((AuthenticationController.sharedController.currentProfile!.identifier?.integerValue)!, toProfileIdentifier: userID, completionHandler: completionHandler)
        
    }
    
    public func acceptFriend(friend: Friend) {
    
        // Marks friend as accepted
        
        friend.accepted = NSNumber(bool: true)
        
        // Creates new reverse Friend object and marks as accepted
        
        let newFriend: Friend = NSEntityDescription.insertNewObjectForEntityForName(FriendEntityName, inManagedObjectContext: Stack.defaultStack.mainContext!) as! Friend

        newFriend.currentProfile = friend.profile
        newFriend.profile = friend.currentProfile
        newFriend.accepted = NSNumber(bool: true)
        newFriend.identifier = NSNumber(integer: (self.maxIdentifier().integerValue) + 1);
        
        Stack.defaultStack.save()
        
    }
    
    public func requestedFriends() -> [Friend]? {
    
        let request = NSFetchRequest(entityName: Friend.entityName)
        let predicate = NSPredicate(format: "currentProfile.identifier = %@ && accepted = %@", AuthenticationController.sharedController.currentProfile!.identifier!, NSNumber(bool: false))
        request.predicate = predicate
        
        do {
            return try Stack.defaultStack.mainContext?.executeFetchRequest(request) as? [Friend]
        } catch let error as NSError {
            print(error)
            return nil
        }
        
    }
    
    public func friendDictionary(friend: Friend) -> [String: AnyObject?] {
        
        var dictionary: [String: AnyObject?] = Dictionary<String, AnyObject?>()
        
        if let currentProfile = friend.currentProfile as Profile? {
            dictionary[Friend.currentProfileKey] = currentProfile.identifier
        }
        
        if let profile = friend.profile as Profile? {
            dictionary[Friend.profileKey] = profile.identifier
        }
        
        if let accepted = friend.accepted as NSNumber? {
            dictionary[Friend.acceptedKey] = accepted
        }
        
        if let identifier = friend.identifier as NSNumber? {
            dictionary[Friend.identifierKey] = identifier
        }
        
        return dictionary
        
    }
    
    public func addFriendDictionary(dictionary: [String: AnyObject?]) -> Friend? {

        if let currentProfile = dictionary[Friend.currentProfileKey] as! NSNumber? {
            if let profile = dictionary[Friend.profileKey]  as! NSNumber? {
                if let accepted = dictionary[Friend.acceptedKey] as! NSNumber? {
                    if let identifier = dictionary[Friend.identifierKey] as! NSNumber? {
                        return self.addFriend(currentProfile.integerValue, profileIdentifier: profile.integerValue, identifier: identifier.integerValue, accepted: accepted)
                    }
                }
            }
        }
        return nil
        
    }
    
    public func addFriend(currentProfileIdentifier: Int, profileIdentifier: Int, identifier: Int, accepted: NSNumber) -> Friend {
        
        let context = Stack.defaultStack.mainContext

        let friend = NSEntityDescription.insertNewObjectForEntityForName(Friend.entityName, inManagedObjectContext: context!) as! Friend
        
        friend.currentProfile = ProfileController.sharedController.findProfileUsingIdentifier(currentProfileIdentifier)
        friend.profile = ProfileController.sharedController.findProfileUsingIdentifier(profileIdentifier)
        friend.accepted = accepted
        friend.identifier = identifier
        
        Stack.defaultStack.save()
        
        return friend
        
    }
    
    public func findFriendUsingIdentifier(identifier: Int) -> Friend? {
        
        let request = NSFetchRequest(entityName: Friend.entityName)
        let predicate = NSPredicate(format: "identifier = %@", NSNumber(integer: identifier))
        
        request.predicate = predicate
        
        var error: NSError? = nil
        var friends: [AnyObject]?
        do {
            friends = try Stack.defaultStack.mainContext?.executeFetchRequest(request)
        } catch let error1 as NSError {
            error = error1
            print(error)
            friends = nil
        }
        
        if friends?.count > 0 {
            return friends?.first as? Friend
        } else {
            return nil
        }
        
    }

    public func allFriends() -> [Friend]? {
        
        let request = NSFetchRequest(entityName: Friend.entityName)
        
        do {
            return try Stack.defaultStack.mainContext?.executeFetchRequest(request) as? [Friend]
        } catch let error as NSError {
            print(error)
            return nil
        }
    }

    // Needs to be refactored into a superclass
    func maxIdentifier() -> NSNumber {
        
        let fetchRequest = NSFetchRequest(entityName: Profile.entityName)
        
        fetchRequest.fetchLimit = 1;
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "identifier", ascending: false)]
        
        do {
            
            let array = try Stack.defaultStack.mainContext?.executeFetchRequest(fetchRequest)
            if array?.count > 0 {
                let profile: Profile = array?.first as! Profile
                return profile.identifier!
            } else {
                return NSNumber(integer: 0)
            }
            
        } catch {
            return NSNumber(integer: 0)
        }
        
    }
    
}

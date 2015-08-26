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

    public func pendingFriends() -> [Friend] {
        
        let request = NSFetchRequest(entityName: Friend.entityName)
        let predicate = NSPredicate(format: "profile.identifier = %@ && accepted = %@", AuthenticationController.sharedController.currentProfile!.identifier!, NSNumber(bool: false))
        request.predicate = predicate
        
        do {
            return try Stack.defaultStack.mainContext?.executeFetchRequest(request) as! [Friend]
        } catch let error as NSError {
            print(error)
            return []
        }
        
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
        let predicate = NSPredicate(format: "profile = %@", AuthenticationController.sharedController.currentProfile!.identifier!)

        self.updateFriendsWithPredicate(predicate) { (success) -> Void in
            let predicate = NSPredicate(format: "currentProfile = %@", AuthenticationController.sharedController.currentProfile!.identifier!)

            self.updateFriendsWithPredicate(predicate, completionHandler: { (success) -> Void in
                completionHandler(success: true)
            })
        }
    }
    
    func updateFriendsWithPredicate(predicate: NSPredicate, completionHandler:(success: Bool) -> Void) {
    
        if AuthenticationController.sharedController.currentProfile != nil {
            
            // First request all that are my pending requests

            NetworkController.sharedController.fetchRecordsWithType(Friend.entityName, predicate:predicate) { (results) -> Void in
                
                for friendDictionary in results {
                    self.findOrAddFriend(friendDictionary, completionHandler: { (friend) -> Void in
               
                    })
                }
            }
        }
        
        completionHandler(success: false)
        
    }
    
    
    
    public func findOrAddFriend(friendDictionary: [String: AnyObject?], completionHandler:(friend: Friend?) -> Void) {
    
        if let number = friendDictionary[Friend.identifierKey] as! NSNumber? {
            if let friend = self.findFriendUsingIdentifier(number.integerValue) {
                
                self.updateFriendWithDictionary(friend, dictionary: friendDictionary, completionHandler: completionHandler)
                
            } else {
                
                self.addFriendWithDictionary(friendDictionary, completionHandler: completionHandler)
                
            }
            
        } else {
            
            completionHandler(friend: nil)
            
        }
        
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
        
        Stack.defaultStack.save()

        // Send email/request to user
        
        NetworkController.sharedController.postRecord(Friend.entityName, recordDictionary: self.friendDictionary(friend)) { (success, networkIdentifier) -> Void in

            if success {
                completionHandler(success: true, friend: friend, errorMessage: "")
            } else {
                Stack.defaultStack.mainContext?.deleteObject(friend)
                Stack.defaultStack.save()
                completionHandler(success: false, friend: friend, errorMessage: "Failed to send request")
            }
            
        }
        
    }
    
    public func requestFriend(userID: Int, completionHandler:(success: Bool, friend: Friend, errorMessage: String) -> Void) {
        self.requestFriends((AuthenticationController.sharedController.currentProfile!.identifier?.integerValue)!, toProfileIdentifier: userID, completionHandler: completionHandler)
        
    }
    
    public func acceptFriend(friend: Friend, completionHandler:(success: Bool, errorMessage: String) -> Void) {
    
        // Marks friend as accepted
        
        friend.accepted = NSNumber(bool: true)
        
        let recordDictionary: [String: AnyObject?] = [
            Friend.identifierKey: friend.identifier,
            Friend.currentProfileKey: friend.currentProfile?.identifier,
            Friend.profileKey: friend.profile?.identifier,
            Friend.acceptedKey: NSNumber(bool: true)
        ]

        NetworkController.sharedController.updateRecord(Friend.entityName, recordDictionary: recordDictionary, completionHandler: { (success, networkIdentifier) -> Void in
            
            if success {
                
                // Create new reverse Friend object and marks as accepted
                
                let newFriend: Friend = NSEntityDescription.insertNewObjectForEntityForName(FriendEntityName, inManagedObjectContext: Stack.defaultStack.mainContext!) as! Friend
                
                newFriend.currentProfile = friend.profile
                newFriend.profile = friend.currentProfile
                newFriend.accepted = NSNumber(bool: true)
                newFriend.identifier = NSNumber(integer: (self.maxIdentifier().integerValue) + 1);
                
                let newRecordDictionary: [String: AnyObject?] = [
                    Friend.identifierKey: newFriend.identifier,
                    Friend.currentProfileKey: newFriend.currentProfile?.identifier,
                    Friend.profileKey: newFriend.profile?.identifier,
                    Friend.acceptedKey: NSNumber(bool: true)
                ]
                
                NetworkController.sharedController.postRecord(Friend.entityName, recordDictionary: newRecordDictionary, completionHandler: { (success, networkIdentifier) -> Void in
                    
                    if success {
                        Stack.defaultStack.save()
                        
                        completionHandler(success: true, errorMessage: "")
                        
                    } else {
                        Stack.defaultStack.mainContext?.delete(newFriend)
                        friend.accepted = NSNumber(bool: false)
                        Stack.defaultStack.save()
                        
                        completionHandler(success: false, errorMessage: "Failed to accept request")
                    }
                    
                })

            } else {
            
                friend.accepted = NSNumber(bool: false)
                Stack.defaultStack.save()
                
                completionHandler(success: false, errorMessage: "Failed to accept request")

            }
            
        })
        
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
    
    public func updateFriendWithDictionary(friend: Friend, dictionary: [String: AnyObject?],completionHandler:(friend: Friend?) -> Void) {
        
        if let currentProfile = dictionary[Friend.currentProfileKey] as! NSNumber? {
            if let profile = dictionary[Friend.profileKey]  as! NSNumber? {
                if let accepted = dictionary[Friend.acceptedKey] as! NSNumber? {
                    if let identifier = dictionary[Friend.identifierKey] as! NSNumber? {
                        
                        self.updateFriend(friend, currentProfileIdentifier: currentProfile.integerValue, profileIdentifier: profile.integerValue, identifier: identifier.integerValue, accepted: accepted, completionHandler: completionHandler)
                        
                    } else { completionHandler(friend: friend) } // No identifier
                } else { completionHandler(friend: friend) } // No accepted
            } else { completionHandler(friend: friend) } // No profile
        } else { completionHandler(friend: friend) } // No current profile
    }
    
    public func addFriendWithDictionary(dictionary: [String: AnyObject?], completionHandler:(friend: Friend?) -> Void) {

        if let currentProfile = dictionary[Friend.currentProfileKey] as! NSNumber? {
            if let profile = dictionary[Friend.profileKey]  as! NSNumber? {
                if let accepted = dictionary[Friend.acceptedKey] as! NSNumber? {
                    if let identifier = dictionary[Friend.identifierKey] as! NSNumber? {
                        
                        let context = Stack.defaultStack.mainContext
                        let friend = NSEntityDescription.insertNewObjectForEntityForName(Friend.entityName, inManagedObjectContext: context!) as! Friend

                        return self.updateFriend(friend, currentProfileIdentifier: currentProfile.integerValue, profileIdentifier: profile.integerValue, identifier: identifier.integerValue, accepted: accepted, completionHandler: completionHandler)

                    } else { completionHandler(friend: nil) } // No identifier
                } else { completionHandler(friend: nil) } // No accepted
            } else { completionHandler(friend: nil) } // No profile
        } else { completionHandler(friend: nil) } // No current profile

    }
    
    public func updateFriend(friend: Friend, currentProfileIdentifier: Int, profileIdentifier: Int, identifier: Int, accepted: NSNumber, completionHandler:(friend: Friend?) -> Void) {

        ProfileController.sharedController.findOrFetchProfileUsingIdentifier(currentProfileIdentifier, completionHandler: { (currentProfile) -> Void in

            if currentProfile != nil {
                friend.currentProfile = currentProfile
            } else {
                print("still no currentProfile for friend")
            }
            ProfileController.sharedController.findOrFetchProfileUsingIdentifier(profileIdentifier, completionHandler: { (profile) -> Void in
            
                if profile != nil {
                    friend.profile = profile
                } else {
                    print("still no profile for friend")
                }
        
                friend.accepted = accepted
                friend.identifier = identifier
                
                Stack.defaultStack.save()
                
                completionHandler(friend: friend)
                
            })
            
        })
        
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
        return identifier(max: true)
    }
    
    func minIdentifier() -> NSNumber {
        return identifier(max:false)
    }
    
    func identifier(max max: Bool) -> NSNumber {
        
        let fetchRequest = NSFetchRequest(entityName: Friend.entityName)
        
        fetchRequest.fetchLimit = 1;
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "identifier", ascending: !max)]
        
        do {
            
            let array = try Stack.defaultStack.mainContext?.executeFetchRequest(fetchRequest)
            if array?.count > 0 {
                let friend: Friend = array?.first as! Friend
                return friend.identifier!
            } else {
                return NSNumber(integer: 0)
            }
            
        } catch {
            return NSNumber(integer: 0)
        }

    }
    
}

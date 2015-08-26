//
//  Stack+FakeData.swift
//  Podium
//
//  Created by Joshua Howland on 6/9/15.
//  Copyright © 2015 [insert name here]. All rights reserved.
//

import Foundation
import PodiumKit
import CoreData

private let nameKey = "name"
private let emailKey = "email"
private let phoneKey = "phone"

public let joshEmail = "josh@devmtn.com"
public let calebEmail = "caleb@gmail.com"
public let benEmail = "ben@yahoo.com"
public let timEmail = "tim@me.com"
public let ashleyEmail = "ashley@tannerlabs.com"
public let emmaEmail = "emma@baymax.com"
public let elizaEmail = "eliza@princess.com"
public let beccaEmail = "becca@skirts.com"
public let timCookEmail = "tim@apple.com"
public let philEmail = "phil@apple.com"
public let eddyEmail = "eddy@apple.com"

extension Stack {

    public func clearAllData() {
        Stack.defaultStack.eraseAll()
    }
    
    public func loadFakeData() { // For testing

        // Should create 10 profiles
        // Should be searchable profiles in find friends
        
        let arrayProfiles = [
            [nameKey: "Joshua Howland", emailKey:joshEmail, phoneKey: "801-450-3213"],
            [nameKey: "Caleb Hicks", emailKey:calebEmail, phoneKey: "801-669-4320"],
            [nameKey: "Tim Shadel", emailKey:timEmail, phoneKey: "801-349-8586"],
            [nameKey: "Ben Norris", emailKey:benEmail, phoneKey: "801-8604592"],
            [nameKey: "Ashley Bentley", emailKey:ashleyEmail, phoneKey: "801-792-2809"],
            [nameKey: "Emma Jayne", emailKey:emmaEmail, phoneKey: "801-262-3314"],
            [nameKey: "Eliza Caroline", emailKey:elizaEmail, phoneKey: "801-971-7333"],
            [nameKey: "Becca Cotton", emailKey:beccaEmail, phoneKey: "801-809-4343"],
            [nameKey: "Tim Cook", emailKey:timCookEmail, phoneKey: "706-555-3422"],
            [nameKey: "Phil Schiller", emailKey:philEmail, phoneKey: "702-656-1234"]
        ]
        
        for userDictionary in arrayProfiles {
            ProfileController.sharedController.addProfileName(userDictionary[nameKey]!, email: userDictionary[emailKey]!, phone: userDictionary[phoneKey]!, identifier: self.maxIdentifier().integerValue + 1, userIdentifier: userDictionary[emailKey]!)
        }
        
        // Should create 30 friends
        // Should show list of friends in friends table view
        
        let friends = [
            [calebEmail: joshEmail],
            [calebEmail: benEmail],
            [calebEmail: beccaEmail],
            [calebEmail: philEmail],
            [joshEmail: ashleyEmail],
            [joshEmail: emmaEmail],
            [joshEmail: elizaEmail],
            [timEmail: timCookEmail],
            [timEmail: philEmail],
            [timEmail: emmaEmail],
            [benEmail: philEmail],
            [ashleyEmail: emmaEmail],
            [ashleyEmail: elizaEmail],
            [ashleyEmail: beccaEmail],
            [beccaEmail: timCookEmail]
        ]
        
        for friendshipDictionary: Dictionary in friends {
            
            let fromFriend: String = friendshipDictionary.keys.array[0]
            let toFriend: String = friendshipDictionary[fromFriend]!
            
            let fromProfile: Profile? = ProfileController.sharedController.findProfileUsingEmail(fromFriend)
            let toProfile: Profile? = ProfileController.sharedController.findProfileUsingEmail(toFriend)
            
            if let currentProfile = fromProfile, let profile = toProfile {
            
                FriendController.sharedController.requestFriends((currentProfile.identifier?.integerValue)!, toProfileIdentifier: (profile.identifier?.integerValue)!, completionHandler: { (success, friend, errorMessage) -> Void in
                    
                    FriendController.sharedController.acceptFriend(friend, completionHandler: { (success, errorMessage) -> Void in
                        
                        
                    })

                })
            
            } else {
                print("Didn't create friend")
            }
            
        }
        
        
        
        
        // Should create 2 invite
        // Siging up with that one invite should auto add them as a friend
        
        let invites = [
            [joshEmail: eddyEmail],
            [joshEmail: "aidyn@michaelangelo.com"]
        ]
        
        for inviteDictionary: Dictionary in invites {
        
            let fromFriend: String = inviteDictionary.keys.array[0]
            let toFriend: String = inviteDictionary[fromFriend]!

            InviteController.sharedController.inviteFromEmail(fromFriend, email: toFriend)
            
        }
    }
    
    public func maxIdentifier() -> NSNumber {
        
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
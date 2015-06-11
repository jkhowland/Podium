//
//  StackDevelopmentFakeData.swift
//  Podium
//
//  Created by Joshua Howland on 6/10/15.
//  Copyright © 2015 [insert name here]. All rights reserved.
//

import Foundation

import PodiumKit

private let nameKey = "name"
private let emailKey = "email"
private let phoneKey = "phone"

public let joshEmail = "me@jkhowland.com"
public let calebEmail = "calebhicks@gmail.com"
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
    
    public func clearDevelopmentData() {
        if let invites = InviteController.sharedController.allInvites() {
            for invite in invites {
                Stack.defaultStack.mainContext?.deleteObject(invite)
            }
            Stack.defaultStack.save()
        }
        
        if let friends = FriendController.sharedController.allFriends() {
            for friend in friends {
                Stack.defaultStack.mainContext?.deleteObject(friend)
            }
            Stack.defaultStack.save()
        }
        
        if let profiles = ProfileController.sharedController.allProfiles() {
            for profile in profiles {
                Stack.defaultStack.mainContext?.deleteObject(profile)
            }
            Stack.defaultStack.save()
        }
    }
    
    public func loadDevelopmentData() { // For testing
        
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
            ProfileController.sharedController.addUser(userDictionary[nameKey]!, email: userDictionary[emailKey]!, phone: userDictionary[phoneKey]!, userIdentifier: userDictionary[emailKey]!)
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
            
            if let fromProfile = fromProfile, let toProfile = toProfile {
                
                let friend = FriendController.sharedController.requestFriends((fromProfile.identifier?.integerValue)!, toProfileIdentifier: (toProfile.identifier?.integerValue)!)
                FriendController.sharedController.acceptFriend(friend)
                
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
    
}
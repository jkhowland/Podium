//
//  Stack+FakeData.swift
//  Podium
//
//  Created by Joshua Howland on 6/9/15.
//  Copyright © 2015 [insert name here]. All rights reserved.
//

import Foundation

let nameKey = "name"
let emailKey = "email"
let phoneKey = "phone"

extension Stack {

    public func clearAllData() {
        
        
    }
    
    public func loadFakeData() { // For testing

        // Should create 10 profiles
        // Should be searchable profiles in find friends
        
        let arrayProfiles = [
            [nameKey: "Joshua Howland", emailKey:"josh@devmtn.com", phoneKey: "801-450-3213"],
            [nameKey: "Caleb Hicks", emailKey:"caleb@gmail.com", phoneKey: "801-669-4320"],
            [nameKey: "Tim Shadel", emailKey:"tim@me.com", phoneKey: "801-349-8586"],
            [nameKey: "Ben Norris", emailKey:"ben@yahoo.com", phoneKey: "801-8604592"],
            [nameKey: "Ashley Bentley", emailKey:"ashley@tannerlabs.com", phoneKey: "801-792-2809"],
            [nameKey: "Emma Jayne", emailKey:"emma@baymax.com", phoneKey: "801-262-3314"],
            [nameKey: "Eliza Caroline", emailKey:"eliza@princess.com", phoneKey: "801-971-7333"],
            [nameKey: "Becca Cotton", emailKey:"becca@skirts.com", phoneKey: "801-809-4343"],
            [nameKey: "Tim Cook", emailKey:"tim@apple.com", phoneKey: "706-555-3422"],
            [nameKey: "Phil Schiller", emailKey:"phil@apple.com", phoneKey: "702-656-1234"]
        ]
        
        for userDictionary in arrayProfiles {
            ProfileController.sharedController.addUser(userDictionary[nameKey]!, email: userDictionary[emailKey]!, phone: userDictionary[phoneKey]!)
        }
        
        // Should create 30 friends
        // Should show list of friends in friends table view
        
        let friends = [
            ["josh@devmtn": "caleb@gmail.com"],
            ["josh@devmtn": "ashley@tannerlabs.com"],
            ["josh@devmtn": "emma@baymax.com"],
            ["josh@devmtn": "eliza@princess.com"],
            ["caleb@gmail.com": "ben@yahoo.com"],
            ["caleb@gmail.com": "becca@skirts.com"],
            ["caleb@gmail.com": "phil@apple.com"],
            ["tim@me.com": "tim@apple.com"],
            ["tim@me.com": "phil@apple.com"],
            ["tim@me.com": "emma@baymax.com"],
            ["ben@yahoo.com": "phil@apple.com"],
            ["ashley@tannerlabs.com": "emma@baymax.com"],
            ["ashley@tannerlabs.com": "eliza@princess.com"],
            ["ashley@tannerlabs.com": "becca@skirts.com"],
            ["becca@skirts.com": "tim@apple.com"]
        ]
        
        for friendshipDictionary: Dictionary in friends {
            
            let fromFriend: String = friendshipDictionary.keys.array[0]
            let toFriend: String = friendshipDictionary[fromFriend]!
            
            let fromProfile: Profile? = ProfileController.sharedController.findProfileUsingEmail(fromFriend)
            let toProfile: Profile? = ProfileController.sharedController.findProfileUsingEmail(toFriend)
            
            if fromProfile != nil && toProfile != nil {
            
                let friend = FriendController.sharedController.requestFriends((fromProfile!.identifier?.integerValue)!, toProfileIdentifier: (toProfile!.identifier?.integerValue)!)
                FriendController.sharedController.acceptFriend(friend)
            
            }
            
            
        }
        
        // Should create 2 invite
        // Siging up with that one invite should auto add them as a friend
        
        let invites = [
            ["josh@devmtn.com": "eddy@apple.com"],
            ["josh@devmtn.com": "aidyn@michaelangelo.com"]
        ]
        
        
    }
    
}
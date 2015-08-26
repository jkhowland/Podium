//
//  Friend.swift
//  Podium
//
//  Created by Joshua Howland on 6/9/15.
//  Copyright © 2015 [insert name here]. All rights reserved.
//

import Foundation
import CoreData

@objc(Friend)
public class Friend: NSManagedObject {
    public static let entityName = "Friend"

    @NSManaged public var currentProfile: Profile?
    public static let currentProfileKey = "currentProfile"
    
    @NSManaged public var profile: Profile? // Friend to which current user requested
    public static let profileKey = "profile"
    
    @NSManaged public var accepted: NSNumber? // Contains a boolean
    public static let acceptedKey = "accepted"
    
    @NSManaged public var identifier: NSNumber?
    public static let identifierKey = "identifier"

    @NSManaged public var test: NSNumber? // Contains a boolean
    public static let testKey = "test"

}

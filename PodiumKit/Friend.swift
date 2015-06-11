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

}


extension Friend {

    @NSManaged public var currentProfile: Profile?
    @NSManaged public var profile: Profile? // Friend to which current user requested
    @NSManaged public var accepted: NSNumber? // Contains a boolean
    @NSManaged public var identifier: NSNumber?
    
}

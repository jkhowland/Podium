//
//  Friend+CoreDataProperties.swift
//  Podium
//
//  Created by Joshua Howland on 6/9/15.
//  Copyright © 2015 [insert name here]. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension Friend {

    @NSManaged var currentProfile: Profile?
    @NSManaged var profile: Profile? // Friend to which current user requested
    @NSManaged var accepted: NSNumber? // Contains a boolean

}

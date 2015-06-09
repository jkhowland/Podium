//
//  User+CoreDataProperties.swift
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

extension User {

    @NSManaged var email: String?
    @NSManaged var identifier: NSNumber?
    @NSManaged var name: String?
    @NSManaged var friend: NSSet?

}

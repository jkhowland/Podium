//
//  Invite+CoreDataProperties.swift
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

extension Invite {

    @NSManaged var fromUserId: NSNumber?
    @NSManaged var toUserEmail: String?
    @NSManaged var identifier: NSNumber?

}

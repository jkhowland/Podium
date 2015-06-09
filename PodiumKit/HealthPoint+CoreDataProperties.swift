//
//  HealthPoint+CoreDataProperties.swift
//  Podium
//
//  Created by Ben Norris on 6/9/15.
//  Copyright © 2015 [insert name here]. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension HealthPoint {

    @NSManaged var date: NSDate?
    @NSManaged var amount: NSNumber?
    @NSManaged var type: NSNumber?
    @NSManaged var user: User?

}

//
//  User.swift
//  Podium
//
//  Created by Joshua Howland on 6/7/15.
//  Copyright (c) 2015 [insert name here]. All rights reserved.
//

import Foundation
import CoreData

@objc(User)

public class User: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var email: String
    @NSManaged var identifier: NSNumber

}

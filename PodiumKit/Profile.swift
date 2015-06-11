//
//  Profile.swift
//  Podium
//
//  Created by Joshua Howland on 6/9/15.
//  Copyright © 2015 [insert name here]. All rights reserved.
//

import Foundation
import CoreData

@objc(Profile)
public class Profile: NSManagedObject {

    public static let entityName = "Profile"

    @NSManaged public var phone: String?
    @NSManaged public var email: String?
    @NSManaged public var identifier: NSNumber?
    @NSManaged public var name: String?
    @NSManaged public var friends: NSSet?
    @NSManaged public var userRecordName: String?

}

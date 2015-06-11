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
    public static let phoneKey = "phone"

    @NSManaged public var email: String?
    public static let emailKey = "email"

    @NSManaged public var identifier: NSNumber?
    public static let identifierKey = "identifier"

    @NSManaged public var name: String?
    public static let nameKey = "name"

    @NSManaged public var userRecordName: String?
    public static let userRecordKey = "userRecordName"
    
    @NSManaged public var friends: NSSet?

}

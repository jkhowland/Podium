//
//  Profile.swift
//  Podium
//
//  Created by Joshua Howland on 6/9/15.
//  Copyright © 2015 [insert name here]. All rights reserved.
//

import Foundation
import CoreData

@objc public class Profile: NSManagedObject {
    public static let entityName = "Profile"

}


extension Profile {

    @NSManaged var phone: String?
    @NSManaged var email: String?
    @NSManaged var identifier: NSNumber?
    @NSManaged var name: String?
    @NSManaged var friend: NSSet?
    
}

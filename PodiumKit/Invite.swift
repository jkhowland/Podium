//
//  Invite.swift
//  Podium
//
//  Created by Joshua Howland on 6/9/15.
//  Copyright © 2015 [insert name here]. All rights reserved.
//

import Foundation
import CoreData

@objc public class Invite: NSManagedObject {

    public static let entityName = "Invite"

}


extension Invite {

    @NSManaged var fromUserId: NSNumber?
    @NSManaged var toUserEmail: String?
    @NSManaged var identifier: NSNumber?
    
}

//
//  HealthPoint.swift
//  Podium
//
//  Created by Ben Norris on 6/9/15.
//  Copyright © 2015 [insert name here]. All rights reserved.
//

import Foundation
import CoreData

enum HealthPointType: NSNumber {
    case Steps = 0
    case Calories
    case Water
}


@objc public class HealthPoint: NSManagedObject {

    public static let entityName = "HealthPoint"

}


extension HealthPoint {

    @NSManaged var date: NSDate?
    @NSManaged var amount: NSNumber?
    @NSManaged var type: NSNumber?
    @NSManaged var user: Profile?
    
}


extension HealthPoint {
    var pointType: HealthPointType? {
        get {
            guard let _type = self.type else { return nil }
            return HealthPointType(rawValue: _type)
        }
        set {
            self.type = self.pointType?.rawValue
        }
    }
}

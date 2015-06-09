//
//  HealthPoint+TypeEnum.swift
//  Podium
//
//  Created by Ben Norris on 6/9/15.
//  Copyright © 2015 [insert name here]. All rights reserved.
//

import Foundation

enum HealthPointType: NSNumber {
    case Steps = 0
    case Calories
    case Water
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
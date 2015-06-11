//
//  OverlayBlurView.swift
//  Podium
//
//  Created by Joshua Howland on 6/11/15.
//  Copyright © 2015 [insert name here]. All rights reserved.
//

import UIKit

class OverlayBlurView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
     
        self.addSubview(self.toolbar)
    }
    
    lazy var toolbar: UIToolbar = {
        
        var toolbar: UIToolbar = UIToolbar(frame: self.bounds)
        toolbar.userInteractionEnabled = false
        toolbar.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        toolbar.backgroundImageForToolbarPosition(.Any, barMetrics:.Default)

        return toolbar
        }()
    
    var blurTintColor: UIColor? {
        set {
            self.toolbar.barTintColor = blurTintColor
        }
        get {
            return self.toolbar.barTintColor
        }
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

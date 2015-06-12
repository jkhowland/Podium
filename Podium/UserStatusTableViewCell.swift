//
//  UserStatusTableViewCell.swift
//  Podium
//
//  Created by Caleb Hicks on 6/9/15.
//  Copyright (c) 2015 [insert name here]. All rights reserved.
//

import UIKit
import PodiumKit

@IBDesignable

class UserStatusTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var statusView1: ProgressView!
    @IBOutlet weak var statusView2: ProgressView!
    @IBOutlet weak var statusView3: ProgressView!
    
    override func prepareForInterfaceBuilder() {
        // Prepare for Interface Builder IBDesignable
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateWithProfile(profile: Friend) {
        self.nameLabel.text = profile.profile!.name
        
        let waterProgress: Float = 0.2
        let stepProgress: Float = 0.4
        let calorieProgress: Float = 0.8
        
        self.statusView1.animateProgressViewToProgress(waterProgress)
        self.statusView2.animateProgressViewToProgress(stepProgress)
        self.statusView3.animateProgressViewToProgress(calorieProgress)
        
    }

}

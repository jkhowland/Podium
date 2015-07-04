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
    
    @IBOutlet weak var progressLabel1: UILabel!
    @IBOutlet weak var progressLabel2: UILabel!
    @IBOutlet weak var progressLabel3: UILabel!
    
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
    
    func updateWithProfile(profile: Profile) {
        self.nameLabel.text = profile.name
        
        let waterProgress: Float = 0.2
        let stepProgress: Float = 0.4
        let calorieProgress: Float = 0.8

        progressLabel1.text = "\(waterProgress)"
        progressLabel2.text = "\(stepProgress)"
        progressLabel3.text = "\(calorieProgress)"
        
    }

}

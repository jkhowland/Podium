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
    
    func updateWithFriend(friend: Friend) {
        self.nameLabel.text = "Found a friend"
    }

}

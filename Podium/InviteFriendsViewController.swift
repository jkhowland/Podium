//
//  InviteFriendsViewController.swift
//  Podium
//
//  Created by Joshua Howland on 6/12/15.
//  Copyright © 2015 [insert name here]. All rights reserved.
//

import UIKit
import PodiumKit

class InviteFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var allProfiles: [Profile]?
    var allRequestedFriends: [Friend]?
    
    @IBOutlet var tableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.allProfiles = ProfileController.sharedController.allProfiles()
        self.allRequestedFriends = FriendController.sharedController.requestedFriends()
        
        ProfileController.sharedController.updateProfiles({ (success) -> Void in

            self.allProfiles = ProfileController.sharedController.allProfiles()
            
            FriendController.sharedController.updateFriends { (success) -> Void in
                
                self.allRequestedFriends = FriendController.sharedController.requestedFriends()
                dispatch_after(0, dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }

        })
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let allProfiles = self.allProfiles {
            if indexPath.row < allProfiles.count {
                let profile = allProfiles[indexPath.row]
                
                FriendController.sharedController.requestFriend((profile.identifier?.integerValue)!, completionHandler: { (success, friend, errorMessage) -> Void in
                  
                    self.tableView.reloadData()
                    
                })
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let allProfiles = self.allProfiles {
            return allProfiles.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("availableFriendCell")
        
        if let allProfiles = self.allProfiles {
            if indexPath.row < allProfiles.count {
                let profile = allProfiles[indexPath.row]
                cell?.textLabel?.text = profile.name
                
                if let _ = FriendController.sharedController.friendForProfile(profile) {
                    cell?.accessoryType = .Checkmark
                }
                
            }
        }
        return cell!
    }
}

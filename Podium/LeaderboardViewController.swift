//
//  LeaderboardViewController.swift
//  Podium
//
//  Created by Caleb Hicks on 6/9/15.
//  Copyright (c) 2015 [insert name here]. All rights reserved.
//

import UIKit
import PodiumKit

enum SortOption {
    case BySteps
    case ByCalories
    case ByWater
}

class LeaderboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    let UserStatusCellIdentifier = "UserStatusCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        FriendController.sharedController.updateFriends { (success) -> Void in
            FriendController.sharedController.resetFriends()
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(UserStatusCellIdentifier) as! UserStatusTableViewCell

        if indexPath.section == 0 {
            if let friend = FriendController.sharedController.pendingFriends()[indexPath.row] as Friend? {
                cell.updateWithProfile(friend.currentProfile!)
            }
        } else {
            if let friend = FriendController.sharedController.friends[indexPath.row] as Friend? {
                cell.updateWithProfile(friend.profile!)
            }
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Pending requests"
        }
        return "Friends"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return FriendController.sharedController.pendingFriends().count
        }
        return FriendController.sharedController.friends.count

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            if let friend = FriendController.sharedController.pendingFriends()[indexPath.row] as Friend? {
                let alertController = UIAlertController(title: "Accept " + (friend.currentProfile?.name!)! + " as your friend?", message: "", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                }
                
                alertController.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    FriendController.sharedController.acceptFriend(friend, completionHandler: { (success, errorMessage) -> Void in
                        self.tableView.reloadData()
                    })
                }
                
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true) {

                }
            }

        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

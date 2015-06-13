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
    
    let UserStatusCellIdentifier = "UserStatusCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        FriendController.sharedController.resetFriends()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(UserStatusCellIdentifier) as! UserStatusTableViewCell
        let friendProfile = FriendController.sharedController.friends[indexPath.row]
        
        cell.updateWithProfile(friendProfile)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendController.sharedController.friends.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
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

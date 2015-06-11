//
//  LoadingViewController.swift
//  Podium
//
//  Created by Joshua Howland on 6/11/15.
//  Copyright © 2015 [insert name here]. All rights reserved.
//

import UIKit
import PodiumKit

class LoadingViewController: UIViewController {

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var loginLabel: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        
        self.loginLabel.hidden = true
        self.getStarted(nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func getStarted(sender: AnyObject?) {
        
        AuthenticationController.sharedController.getStartedStoryboard { (storyboardID) -> Void in
            if let storyboardID = storyboardID {
                dispatch_after(0, dispatch_get_main_queue(), { () -> Void in
                    self.performSegueWithIdentifier(storyboardID, sender: self)
                })
            } else {
                self.activityIndicator.hidden = true
                self.loginLabel.hidden = false
            }
        }
    }
}

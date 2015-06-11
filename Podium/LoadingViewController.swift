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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.activityIndicator.startAnimating()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func getStarted(sender: AnyObject?) {
        
        AuthenticationController.sharedController.getStartedStoryboard { (storyboardID) -> Void in
            let storyboard = UIStoryboard(name: storyboardID, bundle: nil)
            let viewController = storyboard.instantiateInitialViewController()
            
            self.navigationController?.pushViewController(viewController!, animated: true)
        }
    }
    
}

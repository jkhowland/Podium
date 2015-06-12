//
//  SignUpViewController.swift
//  Podium
//
//  Created by Joshua Howland on 6/11/15.
//  Copyright © 2015 [insert name here]. All rights reserved.
//

import UIKit
import PodiumKit

class SignUpViewController: UIViewController {

    @IBOutlet var nameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var phoneField: UITextField!
    @IBOutlet var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func next(sender: AnyObject) {
        
        self.nextButton.enabled = false
        
        if self.nameField.text?.characters.count > 0 && self.isValidEmail(self.emailField.text!) {
            
            AuthenticationController.sharedController.signUp(self.nameField.text!, email: self.emailField.text!, phone: self.phoneField.text!, completionHandler: { (success, error) -> Void in
                
                self.performSegueWithIdentifier("next", sender: self)
                
            })
            
        }
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
}

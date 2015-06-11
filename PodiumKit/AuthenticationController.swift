//
//  AuthenticationController.swift
//  TeamStatusCore
//
//  Created by Joshua Howland on 6/4/15.
//  Copyright (c) 2015 Team Status. All rights reserved.
//

import Foundation

let storyboardLoading = "Loading"
let storyboardBaseApp = "BaseApp"
let storyboardSignInFlow = "SignInFlow"
let storyboardSignUpFlow = "SignUpFlow"

public class AuthenticationController: NSObject {
    public static let sharedController = AuthenticationController()

    public var currentProfile: Profile?
    
    public func welcomeStoryboardIdentifier() -> String {

        if self.currentProfile == nil {
            return storyboardLoading
        } else {
            return storyboardBaseApp
        }
    }
    
    public func getStartedStoryboard(completionHandler: (storyboardID: String?) -> Void) {
        
        NetworkController.sharedController.userRecord { (record) -> Void in
            if let record = record {
                let predicate = NSPredicate(format: "\(userIdentifierKey) = %@", record)
                NetworkController.sharedController.fetchRecordsWIthType(Profile.entityName, predicate: predicate, completionHandler: { (results) -> Void in
                    
                    if results.count > 0 {
                        completionHandler(storyboardID: storyboardBaseApp)
                    } else {
                        completionHandler(storyboardID: storyboardSignUpFlow)
                    }
                })
            } else {
                completionHandler(storyboardID: nil)
            }
        }
    }
    
    public func signIn(profile: Profile) {
        self.currentProfile = profile
    }
    
    public func signUp(name: String, email: String, phone: String, userIdentifier: String) {
        let profile = ProfileController.sharedController.addUser(name, email: email, phone: phone, userIdentifier: userIdentifier)
        self.currentProfile = profile
        
        InviteController.sharedController.acceptReceivedInvites(email)
        
    }
    
}

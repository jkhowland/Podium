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

    public var currentUserID: String?
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
                self.currentUserID = record
                let predicate = NSPredicate(format: "\(userIdentifierKey) = %@", record)
                NetworkController.sharedController.fetchRecordsWithType(Profile.entityName, predicate: predicate, completionHandler: { (results) -> Void in
                    
                    if results.count > 0 {
                        if self.signIn(results[0]) {
                            completionHandler(storyboardID: storyboardBaseApp)
                        } else {
                            // Could not sign in with profile from CloudKit
                            completionHandler(storyboardID: storyboardSignUpFlow)
                        }
                    } else {
                        completionHandler(storyboardID: storyboardSignUpFlow)
                    }
                })
            } else {
                completionHandler(storyboardID: nil)
            }
        }
    }
    
    public func signIn(profileDictionary: [String: AnyObject?]) -> Bool {
        if let profile = ProfileController.sharedController.findOrAddProfile(profileDictionary) {
            self.currentProfile = profile
            return true
        } else {
            return false
        }
    }
    
    public func signUp(name: String, email: String, phone: String, completionHandler:(success: Bool, error: NSError?) -> Void) {
        
        if self.currentUserID != nil {
            
            NetworkController.sharedController.maxIdentifier(Profile.entityName, completionHandler: { (identifier) -> Void in

                let recordDictionary: [String: AnyObject?] = [
                    Profile.nameKey: name,
                    Profile.emailKey: email,
                    Profile.phoneKey: phone,
                    Profile.userRecordKey: self.currentUserID,
                    Profile.identifierKey: NSNumber(integer: identifier)
                ]
                
                NetworkController.sharedController.postRecord(Profile.entityName, recordDictionary: recordDictionary) { (success, networkIdentifier) -> Void in
                    
                    let profile = ProfileController.sharedController.addProfileName(name, email: email, phone: phone, identifier: identifier, userIdentifier: self.currentUserID!)
                    self.currentProfile = profile
                    
                    InviteController.sharedController.acceptReceivedInvites(email)
                    
                    completionHandler(success: true, error: nil)
                    
                }
                
            })
            
        } else {
            
            completionHandler(success: false, error: nil)
        
        }
    }
    
}

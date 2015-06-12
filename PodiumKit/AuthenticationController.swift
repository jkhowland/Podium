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

    var _currentProfile: Profile?

    public var currentUserID: String? {
        set {
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: Profile.userRecordKey)
            NSUserDefaults.standardUserDefaults().synchronize()
            
        } get {
            if let record = NSUserDefaults.standardUserDefaults().valueForKey(Profile.userRecordKey) as! String? {
                return record
            } else {
                return nil
            }
        }
    }

    public var currentProfile: Profile? {
        set {
            _currentProfile = newValue
        } get {
            if let currentProfile = _currentProfile {
                return currentProfile
            } else  {
                if let currentUserID = self.currentUserID {
                    
                    _currentProfile = ProfileController.sharedController.findProfileUsingUserIdentifier(currentUserID)
                    
                    return _currentProfile
                } else {
                    return nil
                }
            }
        }
    }
    
    public func welcomeStoryboardIdentifier() -> String {
        return storyboardLoading
    }
    
    public func getStartedStoryboard(completionHandler: (storyboardID: String?) -> Void) {
        
        NetworkController.sharedController.userRecord { (record) -> Void in
            if let record = record {
                
                if let profile = self.currentProfile {
                    if profile.userRecordName == record {
                        completionHandler(storyboardID: storyboardBaseApp)
                        return
                    }
                }

                self.currentUserID = record
                
                let predicate = NSPredicate(format: "\(userIdentifierKey) = %@", record)
                NetworkController.sharedController.fetchRecordsWithType(Profile.entityName, predicate: predicate, completionHandler: { (results) -> Void in
                    
                    if results.count > 0 {
                        if self.signIn(results[0]) {
                            completionHandler(storyboardID: storyboardSignInFlow)
                        } else {
                            // Could not sign in with profile from CloudKit
                            completionHandler(storyboardID: storyboardSignUpFlow)
                        }
                    } else {
                        completionHandler(storyboardID: storyboardSignUpFlow)
                    }
                })
            } else {
                // User is not logged in to iCloud
                completionHandler(storyboardID: nil)
            }
        }
    }
    
    public func deleteAccount(completionHandler:(success: Bool, error: NSError?) -> Void) {
    
        if let profile = AuthenticationController.sharedController.currentProfile  {
            NetworkController.sharedController.deleteRecord(Profile.entityName, recordDictionary: ProfileController.sharedController.profileDictionary(profile), completionHandler: { (success) -> Void in
                completionHandler(success: success, error: nil)
            })
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
                    Profile.identifierKey: NSNumber(integer: identifier + 1) // Increment the max identifier
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

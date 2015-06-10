//
//  AuthenticationController.swift
//  TeamStatusCore
//
//  Created by Joshua Howland on 6/4/15.
//  Copyright (c) 2015 Team Status. All rights reserved.
//

import Foundation
import CloudKit

public class AuthenticationController: NSObject {
    public static let sharedController = AuthenticationController()

    public var currentProfile: Profile?
    
    public func signIn() {
        
    }
    
    public func signUp(name: String, email: String, phone: String) {
        let profile = ProfileController.sharedController.addUser(name, email: email, phone: phone)
        CKContainer.defaultContainer().fetchUserRecordIDWithCompletionHandler { (recordID, error) -> Void in
            guard let recordID = recordID else { print("Error \(error)"); return }

            print("Record: \(recordID.recordName)")
            profile.userRecordName = recordID.recordName
        }
    }
    
}

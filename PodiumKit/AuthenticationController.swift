//
//  AuthenticationController.swift
//  TeamStatusCore
//
//  Created by Joshua Howland on 6/4/15.
//  Copyright (c) 2015 Team Status. All rights reserved.
//

import Foundation

public class AuthenticationController: NSObject {
    public static let sharedController = AuthenticationController()

    public lazy var currentProfile: Profile = {
        // returns current profile
        return ProfileController.sharedController.findProfileUsingEmail("josh@devmtn.com")
    }()!
    
    public func signIn() {
        
    }
    
    public func signUp() {
    
    }
    
}

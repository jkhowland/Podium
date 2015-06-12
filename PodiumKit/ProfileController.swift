//
//  ProfileController.swift
//  TeamStatusCore
//
//  Created by Joshua Howland on 6/7/15.
//  Copyright (c) 2015 Team Status. All rights reserved.
//

import CoreData

public class ProfileController: NSObject {
    public static let sharedController = ProfileController()
    
    public func findOrAddProfile(profileDictionary: [String: AnyObject?]) -> Profile? {
        
        if let number = profileDictionary[Profile.identifierKey] as! NSNumber? {
            if let profile = self.findProfileUsingIdentifier(number.integerValue) {
                return profile
            } else {
                if let profile = self.addProfileDictionary(profileDictionary) {
                    return profile
                }
            }
        }

        return nil
    }
    
    public func addProfileDictionary(profileDictionary: [String: AnyObject?]) -> Profile? {

        if let name = profileDictionary[Profile.nameKey] as! String? {
            if let email = profileDictionary[Profile.emailKey] as! String? {
                if let phone = profileDictionary[Profile.phoneKey] as! String? {
                    if let identifier = profileDictionary[Profile.identifierKey] as! NSNumber? {
                        if let userRecord = profileDictionary[Profile.userRecordKey] as! String? {
                            return self.addProfileName(name, email: email, phone: phone, identifier: identifier.integerValue, userIdentifier: userRecord)
                        }
                    }
                }
            }
        }
        
        return nil

    }
    
    public func addProfileName(name: String, email: String, phone: String, identifier: Int, userIdentifier: String) -> Profile {

        let context = Stack.defaultStack.mainContext
        
        let profile = NSEntityDescription.insertNewObjectForEntityForName(Profile.entityName, inManagedObjectContext: context!) as! Profile

        profile.name = name
        profile.email = email
        profile.phone = phone
        profile.identifier = identifier
        profile.userRecordName = userIdentifier
        
        Stack.defaultStack.save()

        return profile
    }

    public func findProfileUsingIdentifier(identifier: Int) -> Profile? {
        
        let request = NSFetchRequest(entityName: "Profile")
        let predicate = NSPredicate(format: "identifier = %@", NSNumber(integer: identifier))
        
        request.predicate = predicate
        
        var error: NSError? = nil
        var users: [AnyObject]?
        do {
            users = try Stack.defaultStack.mainContext?.executeFetchRequest(request)
        } catch let error1 as NSError {
            error = error1
            print(error)
            users = nil
        }
        
        if users?.count > 0 {
            return users?.first as? Profile
        } else {
            return nil
        }
        
    }
    
    public func findProfileUsingEmail(email: String) -> Profile? {
        
        let request = NSFetchRequest(entityName: "Profile")
        let emailPredicate = NSPredicate(format: "email = %@", email)
        
        request.predicate = emailPredicate

        var error: NSError? = nil
        var users: [AnyObject]?
        do {
            users = try Stack.defaultStack.mainContext?.executeFetchRequest(request)
        } catch let error1 as NSError {
            error = error1
            print(error)
            users = nil
        }
        
        if users?.count > 0 {
            return users?.first as? Profile
        } else {
            return nil
        }
        
    }
    
    public func deleteUser(user: Profile) {
    
        user.managedObjectContext?.deleteObject(user)

        Stack.defaultStack.save()
    }
    
    public func allProfiles() -> [Profile]? {
        
        let request = NSFetchRequest(entityName: Profile.entityName)
        
        do {
            return try Stack.defaultStack.mainContext?.executeFetchRequest(request) as? [Profile]
        } catch let error as NSError {
            print(error)
            return nil
        }
    }
}


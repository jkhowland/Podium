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
    
    public func profileDictionary(profile: Profile) -> [String: AnyObject?] {
    
        var dictionary: [String: AnyObject?] = Dictionary<String, AnyObject?>()
        
        if let name = profile.name as String? {
            dictionary[Profile.nameKey] = name
        }

        if let email = profile.email as String? {
            dictionary[Profile.emailKey] = email
        }
        
        if let phone = profile.phone as String? {
            dictionary[Profile.phoneKey] = phone
        }

        if let identifier = profile.identifier as NSNumber? {
            dictionary[Profile.identifierKey] = identifier
        }

        if let userRecord = profile.userRecordName as String? {
            dictionary[Profile.userRecordKey] = userRecord
        }
    
        return dictionary
        
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

    public func findProfileUsingKey(key: String, stringValue: String) -> Profile? {
        
        let request = NSFetchRequest(entityName: Profile.entityName)
        let predicate = NSPredicate(format: "\(key) = %@", stringValue)
        
        request.predicate = predicate
        
        var error: NSError? = nil
        var profiles: [AnyObject]?
        do {
            profiles = try Stack.defaultStack.mainContext?.executeFetchRequest(request)
        } catch let error1 as NSError {
            error = error1
            print(error)
            profiles = nil
        }
        
        if profiles?.count > 0 {
            return profiles?.first as? Profile
        } else {
            return nil
        }
        
    }

    public func findProfileUsingUserIdentifier(userIdentifier: String) -> Profile? {
    
        return self.findProfileUsingKey(Profile.userRecordKey, stringValue: "\(userIdentifier)")
    }
    
    public func findProfileUsingIdentifier(identifier: Int) -> Profile? {
        
        return self.findProfileUsingKey("identifier", stringValue: "\(identifier)")
    }
    
    public func findProfileUsingEmail(email: String) -> Profile? {
        
        return self.findProfileUsingKey("email", stringValue: email)
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


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
        
    public func addUser(name: String, email: String, phone: String) -> Profile {

        let context = Stack.defaultStack.mainContext
        
        let profile = NSEntityDescription.insertNewObjectForEntityForName(Profile.entityName, inManagedObjectContext: context!) as! Profile

        profile.name = name
        profile.email = email
        profile.phone = phone
        profile.identifier = NSNumber(integer: (self.maxIdentifier().integerValue) + 1);
        
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
    

    // Needs to be refactored into a superclass
    func maxIdentifier() -> NSNumber {
        
        let fetchRequest = NSFetchRequest(entityName: Profile.entityName)
        fetchRequest.fetchLimit = 1;
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "identifier", ascending: false)]
        
        do {
            
            let array = try Stack.defaultStack.mainContext?.executeFetchRequest(fetchRequest)
            if array?.count > 0 {
                let profile: Profile = array?.first as! Profile
                return profile.identifier!
            } else {
                return NSNumber(integer: 0)
            }
            
        } catch {
            return NSNumber(integer: 0)
        }
        
    }

}


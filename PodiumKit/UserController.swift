//
//  UserController.swift
//  TeamStatusCore
//
//  Created by Joshua Howland on 6/7/15.
//  Copyright (c) 2015 Team Status. All rights reserved.
//

let UserEntityName = "User"

import CoreData

public class UserController: NSObject {
    public static let sharedController = UserController()
 
    public func addUser(name: String, email: String, identifier: Int64) {
        let user: User = NSEntityDescription.insertNewObjectForEntityForName(UserEntityName, inManagedObjectContext: Stack.defaultStack.mainContext!) as! User
        
        user.name = name
        user.email = email
        user.identifier = NSNumber(longLong: identifier)
        
        Stack.defaultStack.save()
        
    }
    
    public func removeUser(user: User) {
    
        user.managedObjectContext?.deleteObject(user)

        Stack.defaultStack.save()
    }
    
    public func allUsers() -> Array<AnyObject> {
        
        let request = NSFetchRequest(entityName: UserEntityName)
        
        var error: NSError? = nil
        var users: [AnyObject]?
        do {
            users = try Stack.defaultStack.mainContext?.executeFetchRequest(request)
        } catch let error1 as NSError {
            error = error1
            print(error)
            users = nil
        }
        
        return users!
    }
    
}


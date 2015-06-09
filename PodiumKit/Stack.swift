//
//  Stack.swift
//  Podium
//
//  Created by Joshua Howland on 6/7/15.
//  Copyright (c) 2015 [insert name here]. All rights reserved.
//

import CoreData

let sharedAppGroupContainer = "group.in.wearewired.podium"

public class Stack: NSObject {
    public static let defaultStack = Stack()
        
    lazy var mainContext: NSManagedObjectContext? = {
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    lazy var storeURL: NSURL = {
        
        var sharedContainerPath = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(sharedAppGroupContainer)
        
        return sharedContainerPath!.URLByAppendingPathComponent("db.sqlite")
        
        }()
    
    lazy var modelURL: NSURL = {

        var containerBundle = NSBundle(identifier: "in.wearewired.PodiumKit")
        var url = containerBundle?.URLForResource("Model", withExtension: "mom")
        
        return url!
        
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        
        var model = NSManagedObjectModel(contentsOfURL: self.modelURL)!
        var entities = model.entities

        return model
        
        }()
    
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {

        let fileManager = NSFileManager.defaultManager()
        var shouldFail = false
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        
        
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator?
        if !shouldFail && (error == nil) {
            coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            
            var storeType = NSSQLiteStoreType
            
            do {
                try coordinator!.addPersistentStoreWithType(storeType, configuration: nil, URL: self.storeURL, options: nil)
            } catch var error1 as NSError {
                error = error1
                coordinator = nil
            } catch {
                fatalError()
            }
        }
        
        if shouldFail || (error != nil) {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            if error != nil {
                dict[NSUnderlyingErrorKey] = error
            }
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            
            return nil
        } else {
            return coordinator
        }
        
        }()
    
    
    public func save() {
        
        var error: NSError? = nil
        do {
            try Stack.defaultStack.mainContext?.save()
        } catch let error1 as NSError {
            error = error1
            print(error)
        }
    }
    
}



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
        
    lazy public var mainContext: NSManagedObjectContext? = {
        guard let coordinator = self.persistentStoreCoordinator else { return nil }

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

        // Create the coordinator and store
        var coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let storeType = NSSQLiteStoreType
        
        do {
            try coordinator.addPersistentStoreWithType(storeType, configuration: nil, URL: self.storeURL, options: nil)
        } catch let error as NSError {
            return nil
        } catch {
            fatalError()
        }

        return coordinator
    }()


    public func save() {
        do {
            try Stack.defaultStack.mainContext?.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
}



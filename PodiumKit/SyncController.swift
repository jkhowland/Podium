//
//  SyncController.swift
//  TeamStatusCore
//
//  Created by Joshua Howland on 6/5/15.
//  Copyright (c) 2015 Team Status. All rights reserved.
//

import Foundation
import CloudKit

public class SyncController: NSObject {
    public static let sharedController = SyncController()
    
    lazy var privateDatabase: CKDatabase = {
        
        var database = CKContainer.defaultContainer().privateCloudDatabase
        
        return database        

        }() 

    lazy var publicDatabase: CKDatabase = {
        
        var database = CKContainer.defaultContainer().publicCloudDatabase
        
        return database
        
        }()

    
    public func fetchRecordsWIthType(recordType: String, predicate: NSPredicate, completionHandler:(results: [AnyObject]) -> Void) {
    
        let query = CKQuery(recordType: recordType, predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        
        var resultObjects: [AnyObject] = []
        
        queryOperation.recordFetchedBlock = { record in
            resultObjects.append(record)
        }

        queryOperation.queryCompletionBlock = { cursor, error in
            completionHandler(results: resultObjects)
        }
        
        self.publicDatabase.addOperation(queryOperation)
    }
    
    public func setup() {

    }
    
    public func test() {
        
    }
}

//
//  NetworkController.swift
//  Podium
//
//  Created by Joshua Howland on 6/11/15.
//  Copyright © 2015 [insert name here]. All rights reserved.
//

import UIKit
import CloudKit

// All CloudKit Code should be here

let userIdentifierKey = "userRecordName"

public class NetworkController: NSObject {
    public static let sharedController = NetworkController()

    lazy var privateDatabase: CKDatabase = {
        
        var database = CKContainer.defaultContainer().privateCloudDatabase
        
        return database
        
        }()
    
    lazy var publicDatabase: CKDatabase = {
        
        var database = CKContainer.defaultContainer().publicCloudDatabase
        
        return database
        
        }()
    
    public func postRecord(recordType: String, recordDictionary: [String: AnyObject?], completionHandler: (success: Bool, identifier: String?) -> Void) {
    
        let record: CKRecord = CKRecord(recordType: recordType)
        
        for key in recordDictionary.keys.array {
            record[key] = recordDictionary[key] as? CKRecordValue
        }
        
        self.publicDatabase.saveRecord(record) { (record, error) -> Void in
            if error != nil {
                completionHandler(success: false, identifier: nil)
            } else {
                completionHandler(success: true, identifier: record?.recordID.recordName)
            }
        }
    }
    
    
    public func fetchRecordsWithType(recordType: String, predicate: NSPredicate, completionHandler:(results: [AnyObject]) -> Void) {
        
        let queryOperation = CKQueryOperation(query: CKQuery(recordType: recordType, predicate: NSPredicate(value: true)))
        
        var resultObjects: [AnyObject] = []
        
        queryOperation.recordFetchedBlock = { record in
            resultObjects.append(record)
        }
        
        queryOperation.queryCompletionBlock = { cursor, error in
            completionHandler(results: resultObjects)
        }
        
        queryOperation.completionBlock = {
            completionHandler(results: resultObjects)
        }
                
        self.publicDatabase.addOperation(queryOperation)
    }
    
    public func userRecord(completionHandler:(record: String?) -> Void) {
        CKContainer.defaultContainer().fetchUserRecordIDWithCompletionHandler { (recordID, error) -> Void in
            if let recordID = recordID {
                let record = recordID.recordName
                print("Record: \(record)")
                completionHandler(record: record)
            } else {
                completionHandler(record: nil)
            }
        }
    }

}

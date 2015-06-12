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
    
    public func deleteRecord(recordType: String, recordDictionary: [String: AnyObject?], completionHandler: (success: Bool) -> Void) {
        
        var predicateKey = Profile.userRecordKey
        var predicateIdentifier = ""
        if let identifier = recordDictionary[Profile.userRecordKey] as! String? {
            predicateKey = Profile.userRecordKey
            predicateIdentifier = identifier
        } else {
            predicateKey = Profile.identifierKey
            predicateIdentifier = recordDictionary[predicateKey] as! String
        }
        
        let queryOperation = CKQueryOperation(query: CKQuery(recordType: recordType, predicate: NSPredicate(format: "\(predicateKey) = %@", predicateIdentifier)))
        queryOperation.resultsLimit = 1
        
        var resultObjects: [CKRecord] = []
        
        queryOperation.recordFetchedBlock = { record in
            resultObjects.append(record)
        }
        
        queryOperation.queryCompletionBlock = { cursor, error in

            if let record = resultObjects.first as CKRecord? {
                self.publicDatabase.deleteRecordWithID(record.recordID, completionHandler: { (recordID, error) -> Void in
                    completionHandler(success: true)
                })
            }
        }
        
        self.publicDatabase.addOperation(queryOperation)
        
    }
    
    public func postRecord(recordType: String, recordDictionary: [String: AnyObject?], completionHandler: (success: Bool, networkIdentifier: String?) -> Void) {
    
        let record: CKRecord = CKRecord(recordType: recordType)
        
        for key in recordDictionary.keys.array {
            record[key] = recordDictionary[key] as? CKRecordValue
        }
        
        self.publicDatabase.saveRecord(record) { (record, error) -> Void in
            if error != nil {
                completionHandler(success: false, networkIdentifier: nil)
            } else {
                completionHandler(success: true, networkIdentifier: record?.recordID.recordName)
            }
        }
    }
    
    
    public func fetchRecordsWithType(recordType: String, predicate: NSPredicate, completionHandler:(results: [[String: AnyObject?]]) -> Void) {
        
        let queryOperation = CKQueryOperation(query: CKQuery(recordType: recordType, predicate: predicate))
        
        var resultObjects: [[String: AnyObject?]] = []
        
        queryOperation.recordFetchedBlock = { record in
            
            var dictionary: [String: AnyObject?] = Dictionary<String, AnyObject?>()
            
            for key in record.allKeys() {
                dictionary[key] = record[key]
            }
            
            resultObjects.append(dictionary)
        }
        
        queryOperation.queryCompletionBlock = { cursor, error in
            completionHandler(results: resultObjects)
        }
        
        self.publicDatabase.addOperation(queryOperation)
    }
    
    public func maxIdentifier(recordType: String, completionHandler:(identifier: Int) -> Void) {
    
        let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "identifier", ascending: false)]

        let queryOperation = CKQueryOperation(query: query)
        queryOperation.resultsLimit = 1
        queryOperation.desiredKeys = ["identifier"]
        
        queryOperation.recordFetchedBlock = { record in
            if let number = record["identifier"] as! NSNumber? {
                completionHandler(identifier: number.integerValue)
            } else {
                completionHandler(identifier: 1)
            }
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

//
//  NetworkController.swift
//  Podium
//
//  Created by Joshua Howland on 6/11/15.
//  Copyright © 2015 [insert name here]. All rights reserved.
//

import UIKit
import Firebase

// All Firebase Code should be here

let userIdentifierKey = "userRecordName"

public class NetworkController: NSObject {
    public static let sharedController = NetworkController()

    lazy var reference: Firebase = {
        return Firebase(url: "https://podium.firebaseio.com")
    }()
    
    public func testNetworkPost() {
        reference.setValue("Do you have data? You'll love Firebase.")
    }
    
    public func testNetworkRead() {
        reference.observeEventType(.Value, withBlock: { snapshot in
            print("\(snapshot.key) -> \(snapshot.value)")
        })
    }
    
    public func deleteProfile(recordDictionary: [String: AnyObject?], completionHandler: (success: Bool) -> Void) {
        
    }
    
    public func postRecord(recordType: String, recordDictionary: [String: AnyObject?], completionHandler: (success: Bool, networkIdentifier: String?) -> Void) {
    
    }
    
    public func updateRecord(recordType: String, recordDictionary: [String: AnyObject?], completionHandler: (success: Bool, networkIdentifier: String?) -> Void) {
    
    }
    
    public func fetchRecordsWithType(recordType: String, predicate: NSPredicate, completionHandler:(results: [[String: AnyObject?]]) -> Void) {
        
    }
    
    public func maxIdentifier(recordType: String, completionHandler:(identifier: Int) -> Void) {
        completionHandler(identifier: 1)
    }
    
    public func userRecord(completionHandler:(record: String?) -> Void) {
        completionHandler(record: nil)
    }
    
    

}

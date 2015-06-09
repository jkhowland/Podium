//
//  NetworkController.swift
//  TeamStatusCore
//
//  Created by Joshua Howland on 6/5/15.
//  Copyright (c) 2015 Team Status. All rights reserved.
//

import Foundation
import CloudKit

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

    public func setup() {

    }
    
    public func test() {
        
    }
}

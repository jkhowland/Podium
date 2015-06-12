//
//  SignInReturnUITestCase.swift
//  Podium
//
//  Created by Joshua Howland on 6/12/15.
//  Copyright © 2015 [insert name here]. All rights reserved.
//

import Foundation
import XCTest

class SignInReturnUITestCase: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        

        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSignInReturn() {
        
//        let inProgressActivityIndicator = XCUIApplication().activityIndicators["In progress"]
//        for _ in 0...5 {
//            if !inProgressActivityIndicator.exists { break }
//            sleep(2)
//        }
//        
//        let app = XCUIApplication()
//        let myProgressNavigationBar = app.navigationBars["My Progress"]
//        XCTAssert(myProgressNavigationBar.exists)
//        
//        myProgressNavigationBar.buttons["Profile"].tap()
//        XCTAssert(app.navigationBars["Profile"].exists)
//        
//        app.navigationBars["Profile"].buttons["My Progress"].tap()
//        
//        let tabBar = app.tabBars
//        tabBar.buttons["Competitions"].tap()
//        tabBar.buttons["Leaderboard"].tap()
//        tabBar.buttons["My Progress"].tap()

    }
    
}

//
//  RegionTests.swift
//  Iterable-Challenge
//
//  Created by Alex King on 1/28/17.
//  Copyright © 2017 Alex King. All rights reserved.
//

import UserNotifications
import XCTest

@testable import Iterable_Challenge

class RegionTests: XCTestCase {
    
    var subject: Region!
    
    override func setUp() {
        super.setUp()
        self.subject = Region()
        self.subject.id = "22"
        self.subject.latitude = 37.7809412
        self.subject.longitude = -122.4001499
        self.subject.radius = 1000
        self.subject.name = "Iterable HQ"
    }
    
    override func tearDown() {
        self.subject = nil
        super.tearDown()
    }
    
    func testIssuePushNotification() {
        self.subject.issuePushNotification()
        
        let pushExpectation = expectation(description: "Push notification delivered")
        UNUserNotificationCenter.current().getDeliveredNotifications { (notifications) in
            
            pushExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0) { (error) in
            if let error = error {
                print(error)
            }
        }
    }
    
}

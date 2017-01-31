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
    
    func testregisterForLocationTriggeredNotification() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        self.subject.registerForLocationTriggeredNotification()
        
        let expect = expectation(description: "Registered a notification")
        center.getPendingNotificationRequests { requests in
            XCTAssertTrue(requests.count == 1)
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 5.0) { (error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    func testIssuePushNotification() {
        self.subject.issuePushNotification()
        
        let pushExpectation = expectation(description: "Push notification delivered")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            UNUserNotificationCenter.current().getDeliveredNotifications { (notifications) in
                var receivedNotification = false
                for notification in notifications {
                    if notification.request.identifier == "RegionEntered" {
                        receivedNotification = true
                        break
                    }
                }
                XCTAssertTrue(receivedNotification)
                pushExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10.0) { (error) in
            if let error = error {
                print(error)
            }
        }
    }
    
}

//
//  Iterable_ChallengeTests.swift
//  Iterable-ChallengeTests
//
//  Created by Alex King on 1/25/17.
//  Copyright © 2017 Alex King. All rights reserved.
//


import RealmSwift
import UserNotifications
import XCTest

@testable import Iterable_Challenge

class AppDelegateTests: XCTestCase {
    
    var subject: AppDelegate!
    
    override func setUp() {
        super.setUp()
        self.subject = AppDelegate()
    }
    
    override func tearDown() {
        self.subject = nil
        super.tearDown()
    }
    
    func testRegionEnteredNotificationDelivery() {
        let region = Region()
        region.id = "15"
        region.latitude = 37.7809412
        region.longitude = -122.4001499
        region.radius = 1000
        region.name = "Iterable HQ"
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(region)
        }
        
        let circularRegion = region.circularRegionRepresentation
        self.subject.locationManager(self.subject.locationManager, didEnterRegion: circularRegion)
        
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

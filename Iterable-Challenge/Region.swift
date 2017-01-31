//
//  Region.swift
//  Iterable-Challenge
//
//  Created by Alex King on 1/25/17.
//  Copyright © 2017 Alex King. All rights reserved.
//

import CoreLocation
import Foundation
import UserNotifications
import RealmSwift

class Region: Object {
    
    dynamic var id: String = ""
    dynamic var latitude: CLLocationDegrees = 0
    dynamic var longitude: CLLocationDegrees = 0
    dynamic var radius: Double = 0
    dynamic var name = ""
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
    var circularRegionRepresentation: CLCircularRegion {
        let region = CLCircularRegion(center: self.coordinate, radius: self.radius, identifier: self.id)
        region.notifyOnEntry = true
        region.notifyOnExit = false
        return region
    }
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    func registerForLocationTriggeredNotification() {
        let content = UNMutableNotificationContent()
        content.body = "You are now at " + self.name
        content.sound = UNNotificationSound.default()
        
        let trigger = UNLocationNotificationTrigger(region: self.circularRegionRepresentation, repeats: true)
        
        let notification = UNNotificationRequest(identifier: self.id, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(notification) { (error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    func issuePushNotification() {
        let content = UNMutableNotificationContent()
        content.body = "You are now at " + self.name
        content.sound = UNNotificationSound.default()
        
        let notification = UNNotificationRequest(identifier: "RegionEntered", content: content, trigger: nil)
        let center = UNUserNotificationCenter.current()
        center.add(notification) { (error) in
            if let error = error {
                print(error)
            }
        }
    }
}

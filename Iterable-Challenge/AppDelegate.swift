//
//  AppDelegate.swift
//  Iterable-Challenge
//
//  Created by Alex King on 1/25/17.
//  Copyright © 2017 Alex King. All rights reserved.
//

import CoreLocation
import RealmSwift
import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let locationManager = CLLocationManager()
    private var regionFetcher: RegionFetcher?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let rootViewController = BaseViewController()
        let window = UIWindow.init(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = rootViewController
        self.window = window
        
        locationManager.delegate = self
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization
            if granted {
                self.locationManager.requestAlwaysAuthorization()
                return
            }
            print("Notification authorization error! \(error)")
            
            let authorizationAlert = UIAlertController(title: "Notifications Not Available", message: "Please use the Settings app to change your notification preferences", preferredStyle: .alert)
            
            let acceptAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                authorizationAlert.presentingViewController?.dismiss(animated: true, completion: nil)
            })
            authorizationAlert.addAction(acceptAction)
            
            guard let window = self.window else {
                return
            }
            guard let viewController = window.rootViewController else {
                return
            }
            viewController.present(authorizationAlert, animated: true, completion: nil)
            
        }
        center.removeAllPendingNotificationRequests()
        
        return true
    }
    
    func beginFetch() {
        let mapper = RegionMapper()
        let regionFetcher = RegionFetcher(withRegionMapper: mapper)
        regionFetcher.fetchRegions()
        self.regionFetcher = regionFetcher
    }
    
}

extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .notDetermined {
            return
        }
        if status != .authorizedAlways {
            print("Location authorization error! Current authorization status: \(status.rawValue)")
            
            let authorizationAlert = UIAlertController(title: "Location Data Not Available", message: "Please use the Settings app to change your location sharing preferences", preferredStyle: .alert)
            
            let acceptAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                authorizationAlert.presentingViewController?.dismiss(animated: true, completion: nil)
            })
            authorizationAlert.addAction(acceptAction)
            
            guard let window = self.window, let viewController = window.rootViewController else {
                return
            }
            viewController.present(authorizationAlert, animated: true, completion: nil)
            
            return
        }
        
        self.beginFetch()
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            let realm = try! Realm()
            guard let realmRegion = realm.object(ofType: Region.self, forPrimaryKey: region.identifier) else {
                return
            }
            realmRegion.issuePushNotification()
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert , .sound])
    }
    
}

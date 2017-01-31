//
//  BaseViewController.swift
//  Iterable-Challenge
//
//  Created by Alex King on 1/25/17.
//  Copyright © 2017 Alex King. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class BaseViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var realmNotification: NotificationToken?
    var updatedLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsUserLocation = true
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        mapView.delegate = self
        
        self.getRealmUpdates()
    }
    
    func getRealmUpdates() {
        let realm = try! Realm()

        let regionObjects = realm.objects(Region.self)
        self.realmNotification = regionObjects.addNotificationBlock { (change) in
            switch change {
            case .update(let regions, _, let insertions, let modifications):
                for index in insertions+modifications {
                    let region = regions[index]
                    self.mapView.add(MKCircle(center: region.coordinate, radius: region.radius), level:MKOverlayLevel.aboveLabels)
                }
                break
            default:
                break
            }
        }
    }
    
}

extension BaseViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if updatedLocation == false {
            let camera = mapView.camera
            camera.centerCoordinate = mapView.userLocation.coordinate
            camera.altitude = 70000
            mapView.setCamera(camera, animated: true)
            updatedLocation = true
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKCircleRenderer(overlay: overlay)
        renderer.lineWidth = 1.0
        renderer.strokeColor = .orange
        renderer.fillColor = UIColor.orange.withAlphaComponent(0.4)
        return renderer
    }
    
}

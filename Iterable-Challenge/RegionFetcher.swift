//
//  RegionFetcher.swift
//  Iterable-Challenge
//
//  Created by Alex King on 1/25/17.
//  Copyright © 2017 Alex King. All rights reserved.
//

import CoreLocation
import Foundation
import RealmSwift

class RegionFetcher: AnyObject {
    
    let regionsURLString = "https://demo6046555.mockable.io/iterable-challenge.json"
    
    let mapper: RegionMapper
    
    init(withRegionMapper mapper: RegionMapper) {
        self.mapper = mapper
        URLSession.shared.configuration.requestCachePolicy = .reloadIgnoringCacheData
    }
    
    func fetchRegions() {
        guard let regionsURL = URL(string: regionsURLString) else {
            return
        }
        
        URLSession.shared.dataTask(with: regionsURL) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let data = data, error == nil
            else {
                print("Error fetching regions:\nResponse: \(response)\nError: \(error)")
                return
            }
            
            guard let jsonData = try! JSONSerialization.jsonObject(with: data) as? [[String:Any]] else {
                return
            }
            
            let locationManager = CLLocationManager()
            let realm = try! Realm()
            for regionJSON in jsonData {
                guard let region = self.mapper.map(fromJSON: regionJSON) else {
                    continue
                }
                
                try! realm.write {
                    realm.add(region, update: true)
                }
                
                locationManager.startMonitoring(for: region.circularRegionRepresentation)
            }
        }.resume()
    }
    
}

class RegionMapper: AnyObject {
    
    func map(fromJSON jsonObject: [String:Any]) -> Region? {
        let region = Region()
        
        guard let id = jsonObject["id"] as? String else {
            return nil
        }
        region.id = id
        
        if let latitude = jsonObject["lat"] as? Double {
            region.latitude = latitude
        }
        if let longitude = jsonObject["lon"] as? Double {
            region.longitude = longitude
        }
        if let radius = jsonObject["radius"] as? Double {
            region.radius = radius
        }
        if let name = jsonObject["name"] as? String {
            region.name = name
        }
        
        return region
    }
    
}

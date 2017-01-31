//
//  RegionMapperTests.swift
//  Iterable-Challenge
//
//  Created by Alex King on 1/30/17.
//  Copyright © 2017 Alex King. All rights reserved.
//

import XCTest

@testable import Iterable_Challenge

class RegionMapperTests: XCTestCase {
    
    var subject: RegionMapper!
    
    override func setUp() {
        super.setUp()
        self.subject = RegionMapper()
    }
    
    override func tearDown() {
        self.subject = nil
        super.tearDown()
    }
    
    func testMap() {
        var region: Region?
        
        let mockJSON = ["id": "2", "lat": 27.4552, "lon": 122.49023, "radius": 25.0, "name": "Random"] as [String: Any]
        region = self.subject.map(fromJSON: mockJSON)
        
        XCTAssertNotNil(region)
        XCTAssertEqual(region?.id, mockJSON["id"] as? String)
        XCTAssertEqual(region?.latitude, mockJSON["lat"] as? Double)
        XCTAssertEqual(region?.longitude, mockJSON["lon"] as? Double)
        XCTAssertEqual(region?.radius, mockJSON["radius"] as? Double)
        XCTAssertEqual(region?.name, mockJSON["name"] as? String)
        
        XCTAssertNil(self.subject.map(fromJSON: [:]))
    }
    
}

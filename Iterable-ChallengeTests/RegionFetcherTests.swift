//
//  RegionFetcherTests.swift
//  Iterable-Challenge
//
//  Created by Alex King on 1/30/17.
//  Copyright © 2017 Alex King. All rights reserved.
//

import RealmSwift
import XCTest

@testable import Iterable_Challenge

class RegionFetcherTests: XCTestCase {
    
    var subject: RegionFetcher!
    
    override func setUp() {
        super.setUp()
        let mapper = RegionMapper()
        let fetcher = RegionFetcher(withRegionMapper: mapper)
        self.subject = fetcher
    }
    
    override func tearDown() {
        self.subject = nil
        super.tearDown()
    }
    
    func testFetchRegions() {
        let realm = try! Realm()
        realm.deleteAll()
        
        self.subject.fetchRegions()
        
        let expect = expectation(description: "regions fetched")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            let regionObjects = realm.objects(Region.self)
            XCTAssertTrue(regionObjects.count != 0)
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 10.0) { (error) in
            if let error = error {
                print(error)
            }
        }
    }
    
}

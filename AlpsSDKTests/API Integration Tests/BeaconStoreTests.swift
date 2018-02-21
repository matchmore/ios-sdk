//
//  BeaconStoreTests.swift
//  AlpsSDKTests
//
//  Created by Maciej Burda on 26/10/2017.
//  Copyright © 2018 Matchmore SA. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Alps
@testable import AlpsSDK

class BeaconStoreTests: QuickSpec {
    
    override func spec() {
        TestsConfig.configure()
        let beaconStore = MatchMore.knownBeacons
        
        context("beacons") {
            fit ("get non existing") {
                var nonExistringBeacon: IBeaconTriple?
                beaconStore.find(byId: "NONEXISTING_TEST_ID", completion: { (result) in
                    nonExistringBeacon = result
                })
                expect(nonExistringBeacon).toEventually(beNil())
            }
        }
    }
}

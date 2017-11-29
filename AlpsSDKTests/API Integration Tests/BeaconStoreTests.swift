//
//  BeaconStoreTests.swift
//  AlpsSDKTests
//
//  Created by Maciej Burda on 26/10/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Alps
@testable import AlpsSDK

class BeaconStoreTests: QuickSpec {
    
    override func spec() {
        TestsConfig.setupAPI()
        let beaconStore = BeaconTripleStore()
        
        context("beacons") {
            fit ("get non existing") {
                var nonExistringBeacon: IBeaconTriple?
                beaconStore.find(byId: "NONEXISTING_TEST_ID", completion: { (result) in
                    if case let .success(iBeacon) = result {
                        nonExistringBeacon = iBeacon
                    }
                })
                expect(nonExistringBeacon).toEventually(beNil())
            }
        }
    }
}

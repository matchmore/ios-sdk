//
//  BeaconStoreTests.swift
//  MatchmoreTests
//
//  Created by Maciej Burda on 26/10/2017.
//  Copyright © 2017 Matchmore. All rights reserved.
//

import Foundation
@testable import Matchmore
import Nimble
import Quick

class BeaconStoreTests: QuickSpec {
    override func spec() {
        TestsConfig.configure()
        let beaconStore = Matchmore.knownBeacons

        context("beacons") {
            fit("update triplets") {
                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
                    beaconStore.updateBeaconTriplets(completion: {
                        done()
                    })
                }
                expect(beaconStore.items).toEventuallyNot(beEmpty())
            }
            fit("get non existing") {
                var nonExistringBeacon: IBeaconTriple?
                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
                    beaconStore.find(byId: "NONEXISTING_TEST_ID", completion: { result in
                        nonExistringBeacon = result
                        done()
                    })
                }
                expect(nonExistringBeacon).toEventually(beNil())
            }
            fit("get existing") {
                var nonExistringBeacon: IBeaconTriple?
                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
                    beaconStore.find(byId: "fe349acd-ee44-4428-8bd8-294558635ffe", completion: { result in
                        nonExistringBeacon = result
                        done()
                    })
                }
                expect(nonExistringBeacon).toEventuallyNot(beNil())
            }
        }
    }
}

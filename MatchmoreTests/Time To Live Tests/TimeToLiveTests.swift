//
//  TimeToLiveTests.swift
//  MatchmoreTests
//
//  Created by Maciej Burda on 24/04/2018.
//  Copyright © 2018 Alps. All rights reserved.
//

import Foundation
@testable import Matchmore
import Nimble
import Quick

final class TimeToLiveTests: QuickSpec {
    override func spec() {
        let properties: [String: Any] = [
            "string": "test",
            "number": 100,
            "boolean": true
        ]
        let selector: String = "string = 'test' and number >= 1 and boolean = true"
        _ = Location(latitude: 10, longitude: 10, altitude: 10, horizontalAccuracy: 10, verticalAccuracy: 10)

        TestsConfig.configure()
        let alpsManager = Matchmore.instance

        var errorResponse: ErrorResponse?

        context("Matchmore Manager") {
            beforeEach {
                errorResponse = nil
            }

            fit("create main device") {
                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
                    Matchmore.startUsingMainDevice { result in
                        if case let .failure(error) = result {
                            errorResponse = error
                        }
                        done()
                    }
                }
                expect(alpsManager.mobileDevices.main).toEventuallyNot(beNil())
                expect(alpsManager.mobileDevices.items).toEventuallyNot(beEmpty())
                expect(errorResponse?.message).toEventually(beNil())
            }

            fit("create a publication") {
                let publication = Publication(topic: "Test Topic TTL", range: 4000, duration: 200, properties: properties)
                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
                    Matchmore.createPublicationForMainDevice(publication: publication, completion: { result in
                        if case let .failure(error) = result {
                            errorResponse = error
                        }
                        done()
                    })
                }
                expect(alpsManager.publications.items).toEventuallyNot(beEmpty())
                expect(errorResponse?.message).toEventually(beNil())
            }

            fit("create a subscription with match TTL") {
                let subscription = Subscription(topic: "Test Topic TTL", range: 4000, duration: 200, selector: selector)
                subscription.matchTTL = 5
                subscription.matchDTL = 0
                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
                    Matchmore.createSubscriptionForMainDevice(subscription: subscription, completion: { result in
                        if case let .failure(error) = result {
                            errorResponse = error
                        }
                        done()
                    })
                }
                expect(alpsManager.subscriptions.items).toEventuallyNot(beEmpty())
                expect(errorResponse?.message).toEventually(beNil())
            }

            // NOT STABLE NOW - TBD
//            fit("get two matches matchTTL") {
//                var deliveredMatches: [Match]?
//                let matchDelegate = TestMatchDelegate()
//
//                alpsManager.delegates += matchDelegate
//                alpsManager.matchMonitor.openSocketForMatches()
//
//                if let mainDeviceId = alpsManager.mobileDevices.main?.id {
//                    alpsManager.locationUpdateManager.tryToSend(location: location, for: mainDeviceId)
//                }
//
//                var count = 0
//                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
//                    matchDelegate.onMatch = { matches, _ in
//                        print(matches)
//                        deliveredMatches = matches
//                        if count >= 1 {
//                            done()
//                        }
//                        count += 1
//                    }
//                }
//                alpsManager.delegates -= matchDelegate
//                alpsManager.matchMonitor.stopPollingMatches()
//                expect(count).toEventuallyNot(beGreaterThan(2))
//                expect(deliveredMatches).toEventuallyNot(beEmpty())
//            }
        }
    }

    class TestMatchDelegate: MatchDelegate {
        var onMatch: OnMatchClosure?
        init(_ onMatch: OnMatchClosure? = nil) {
            self.onMatch = onMatch
        }
    }
}

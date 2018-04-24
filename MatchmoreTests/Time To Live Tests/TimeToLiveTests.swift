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
        let location = Location(latitude: 10, longitude: 10, altitude: 10, horizontalAccuracy: 10, verticalAccuracy: 10)

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
                let publication = Publication(topic: "Test Topic", range: 4000, duration: TestsConfig.kWaitTimeInterval, properties: properties)
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
                let subscription = Subscription(topic: "Test Topic", range: 4000, duration: TestsConfig.kWaitTimeInterval, selector: selector)
                subscription.matchTTL = 1
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

            fit("update location") {
                if let mainDeviceId = alpsManager.mobileDevices.main?.id {
                    alpsManager.locationUpdateManager.tryToSend(location: location, for: mainDeviceId)
                }
                expect(alpsManager.locationUpdateManager.lastLocation?.longitude).toEventuallyNot(beNil())
                expect(alpsManager.locationUpdateManager.lastLocation?.latitude).toEventuallyNot(beNil())
            }

            fit("get two matches matchTTL") {
                var deliveredMatches: [Match]?
                let matchDelegate = TestMatchDelegate()

                alpsManager.delegates += matchDelegate
                alpsManager.matchMonitor.startPollingMatches(pollingTimeInterval: 5)

                var timesCalled = 0
                var lastMatchesCount = 0
                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
                    matchDelegate.onMatch = { matches, _ in
                        deliveredMatches = matches
                        lastMatchesCount = matches.count
                        timesCalled += 1
                        if timesCalled >= 1, matches.count - lastMatchesCount == 1 {
                            done()
                        }
                    }
                }
                alpsManager.delegates -= matchDelegate
                alpsManager.matchMonitor.stopPollingMatches()
                expect(deliveredMatches).toEventuallyNot(beEmpty())
            }
        }
    }

    class TestMatchDelegate: MatchDelegate {
        var onMatch: OnMatchClosure?
        init(_ onMatch: OnMatchClosure? = nil) {
            self.onMatch = onMatch
        }
    }
}

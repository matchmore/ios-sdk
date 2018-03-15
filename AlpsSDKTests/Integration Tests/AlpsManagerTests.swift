//
//  AlpsManagerTests.swift
//  AlpsSDKTests
//
//  Created by Maciej Burda on 27/10/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import AlpsSDK

final class AlpsManagerTests: QuickSpec {
    
    override func spec() {
        let properties: [String: Any] = [
            "string": "test",
            "number": 100,
            "boolean": true
        ]
        let selector: String =  "string = 'test' and number >= 1 and boolean = true"
        let location = Location(latitude: 10, longitude: 10, altitude: 10, horizontalAccuracy: 10, verticalAccuracy: 10)
        
        TestsConfig.configure()
        let alpsManager = MatchMore.instance
        
        var errorResponse: ErrorResponse?
        
        context("Alps Manager") {
            
            beforeEach {
                errorResponse = nil
            }
            
            fit ("clear publications") {
                waitUntil(timeout: TestsConfig.kWaitTimeInterval * 4) { done in
                    alpsManager.publications.deleteAll { error in
                        errorResponse = error
                        done()
                    }
                }
                expect(alpsManager.publications.items).to(beEmpty())
                expect(errorResponse?.message).toEventually(beNil())
            }
            
            fit ("clear subscriptions") {
                waitUntil(timeout: TestsConfig.kWaitTimeInterval * 4) { done in
                    alpsManager.subscriptions.deleteAll { error in
                        errorResponse = error
                        done()
                    }
                }
                expect(alpsManager.subscriptions.items).to(beEmpty())
                expect(errorResponse?.message).toEventually(beNil())
            }
            
            fit ("clear mobile devices") {
                waitUntil(timeout: TestsConfig.kWaitTimeInterval * 4) { done in
                    alpsManager.mobileDevices.deleteAll { error in
                        errorResponse = error
                        done()
                    }
                }
                expect(alpsManager.mobileDevices.main).to(beNil())
                expect(alpsManager.mobileDevices.items).to(beEmpty())
                expect(errorResponse?.message).toEventually(beNil())
            }
            
            fit ("create main device") {
                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
                    MatchMore.startUsingMainDevice { result in
                        if case .failure(let error) = result {
                            errorResponse = error
                        }
                        done()
                    }
                }
                expect(alpsManager.mobileDevices.main).toEventuallyNot(beNil())
                expect(alpsManager.mobileDevices.items).toEventuallyNot(beEmpty())
                expect(errorResponse?.message).toEventually(beNil())
            }
            
            fit ("create a publication") {
                let publication = Publication(topic: "Test Topic", range: 4000, duration: 100000, properties: properties)
                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
                    MatchMore.createPublicationForMainDevice(publication: publication, completion: { (result) in
                        if case .failure(let error) = result {
                            errorResponse = error
                        }
                        done()
                    })
                }
                expect(alpsManager.publications.items).toEventuallyNot(beEmpty())
                expect(errorResponse?.message).toEventually(beNil())
            }
            
            fit ("create a subscription") {
                let subscription = Subscription(topic: "Test Topic", range: 4000, duration: 100000, selector: selector)
                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
                    MatchMore.createSubscriptionForMainDevice(subscription: subscription, completion: { (result) in
                        if case .failure(let error) = result {
                            errorResponse = error
                        }
                        done()
                    })
                }
                expect(alpsManager.subscriptions.items).toEventuallyNot(beEmpty())
                expect(errorResponse?.message).toEventually(beNil())
            }
            
            fit ("update location") {
                if let mainDeviceId = alpsManager.mobileDevices.main?.id {
                    alpsManager.locationUpdateManager.tryToSend(location: location, for: mainDeviceId)
                }
                expect(alpsManager.locationUpdateManager.lastLocation?.longitude).toEventuallyNot(beNil())
                expect(alpsManager.locationUpdateManager.lastLocation?.latitude).toEventuallyNot(beNil())
            }
            
            fit ("get polling match") {
                var deliveredMatches: [Match]?
                let matchDelegate = TestMatchDelegate()
                
                alpsManager.delegates += matchDelegate
                alpsManager.matchMonitor.startPollingMatches(pollingTimeInterval: 1)
                
                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
                    matchDelegate.onMatch = { matches, _ in
                        deliveredMatches = matches
                        done()
                    }
                }
                alpsManager.delegates -= matchDelegate
                alpsManager.matchMonitor.stopPollingMatches()
                expect(deliveredMatches).toEventuallyNot(beEmpty())
            }
            
            fit ("get socket match") {
                var deliveredMatches: [Match]?
                let matchDelegate = TestMatchDelegate()
                
                alpsManager.delegates += matchDelegate
                alpsManager.matchMonitor.openSocketForMatches()

                waitUntil(timeout: TestsConfig.kWaitTimeInterval * 4) { done in
                    matchDelegate.onMatch = { matches, _ in
                        deliveredMatches = matches
                        done()
                    }
                    let subscription = Subscription(topic: "Test Topic", range: 4000, duration: 100000, selector: selector)
                    subscription.pushers = ["ws"]
                    MatchMore.createSubscriptionForMainDevice(subscription: subscription, completion: { (result) in
                        if case .failure(let error) = result {
                            errorResponse = error
                        }
                    })
                }
                alpsManager.delegates -= matchDelegate
                alpsManager.matchMonitor.closeSocketForMatches()
                expect(deliveredMatches).toEventuallyNot(beEmpty())
                expect(errorResponse?.message).toEventually(beNil())
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

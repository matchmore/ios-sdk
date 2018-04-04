//
//  PubSubAfterDeviceDeleteTests.swift
//  MatchmoreTests
//
//  Created by Maciej Burda on 13/11/2017.
//  Copyright © 2017 Matchmore. All rights reserved.
//

import Foundation
@testable import Matchmore
import Nimble
import Quick

final class PubSubAfterDeviceDeleteTests: QuickSpec {
    override func spec() {
        TestsConfig.configure()
        let alpsManager = MatchMore.instance
        var errorMesseage: String?

        context("pub/sub delete with device") {
            beforeEach {
                errorMesseage = nil
            }
            fit("create main device") {
                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
                    MatchMore.startUsingMainDevice { result in
                        errorMesseage = result.errorMessage
                        done()
                    }
                }
                expect(alpsManager.mobileDevices.main).toEventuallyNot(beNil())
                expect(alpsManager.mobileDevices.items).toEventuallyNot(beEmpty())
                expect(errorMesseage).toEventually(beNil())
            }

            fit("create a publication") {
                let publication = Publication(topic: "Test Topic", range: 20, duration: TestsConfig.kWaitTimeInterval, properties: ["a": "b"])
                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
                    MatchMore.createPublicationForMainDevice(publication: publication, completion: { result in
                        errorMesseage = result.errorMessage
                        done()
                    })
                }
                expect(alpsManager.publications.items).toEventuallyNot(beEmpty())
                expect(errorMesseage).toEventually(beNil())
            }

            fit("create a subscription") {
                let subscription = Subscription(topic: "Test iTopic", range: 20, duration: TestsConfig.kWaitTimeInterval, selector: "")
                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
                    MatchMore.createSubscriptionForMainDevice(subscription: subscription, completion: { result in
                        errorMesseage = result.errorMessage
                        done()
                    })
                }
                expect(alpsManager.subscriptions.items).toEventuallyNot(beEmpty())
                expect(errorMesseage).toEventually(beNil())
            }
            fit("delete main device and related pub/sub") {
                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
                    if let mainDevice = alpsManager.mobileDevices.main {
                        alpsManager.matchMonitor.stopMonitoringFor(device: mainDevice)
                        alpsManager.mobileDevices.delete(item: mainDevice, completion: { error in
                            errorMesseage = error?.message
                            done()
                        })
                    } else { done() }
                }
                expect(errorMesseage).toEventually(beNil())
                expect(alpsManager.subscriptions.items).toEventually(beEmpty())
                expect(alpsManager.publications.items).toEventually(beEmpty())
                expect(alpsManager.mobileDevices.items).toEventually(beEmpty())
            }
        }
    }
}

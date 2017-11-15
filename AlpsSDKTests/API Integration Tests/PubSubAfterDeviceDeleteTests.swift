//
//  PubSubAfterDeviceDeleteTests.swift
//  AlpsSDKTests
//
//  Created by Maciej Burda on 13/11/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import Alps
@testable import AlpsSDK

final class PubSubAfterDeviceDeleteTests: QuickSpec {
    
    override func spec() {
        let alpsManager = AlpsManager(apiKey: TestsConfig.kApiKey,
                                      baseURL: TestsConfig.kBaseUrl)
        var errorMesseage: String?
        
        context("pub/sub delete with device") {
            beforeEach {
                errorMesseage = nil
            }
            fit ("create main device") {
                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
                    alpsManager.createMainDevice { result in
                        errorMesseage = result.messeage
                        done()
                    }
                }
                expect(alpsManager.mobileDevices.main).toEventuallyNot(beNil())
                expect(alpsManager.mobileDevices.items).toEventuallyNot(beEmpty())
                expect(errorMesseage).toEventually(beNil())
            }
            
            fit ("create a publication") {
                let publication = Publication(topic: "Test Topic", range: 20, duration: 100000, properties: ["": ""])
                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
                    alpsManager.createPublication(publication: publication, completion: { (result) in
                        errorMesseage = result.messeage
                        done()
                    })
                }
                expect(alpsManager.publications.items).toEventuallyNot(beEmpty())
                expect(errorMesseage).toEventually(beNil())
            }
            
            fit ("create a subscription") {
                let subscription = Subscription(topic: "Test Topic", range: 20, duration: 100000, selector: "")
                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
                    alpsManager.createSubscription(subscription: subscription, completion: { (result) in
                        errorMesseage = result.messeage
                        done()
                    })
                }
                expect(alpsManager.subscriptions.items).toEventuallyNot(beEmpty())
                expect(errorMesseage).toEventually(beNil())
            }
            fit ("delete main device and related pub/sub") {
                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
                    if let mainDevice = alpsManager.mobileDevices.main {
                        alpsManager.matchMonitor.stopMonitoringFor(device: mainDevice)
                        alpsManager.mobileDevices.delete(item: mainDevice, completion: { (error) in
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

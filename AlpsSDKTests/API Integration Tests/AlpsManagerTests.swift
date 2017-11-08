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

@testable import Alps
@testable import AlpsSDK

final class AlpsManagerTests: QuickSpec {
    
    override func spec() {
        let properties = ["test": "true"]
        let location = Location(latitude: 10, longitude: 10, altitude: 10, horizontalAccuracy: 10, verticalAccuracy: 10)
        
        var alpsManager = AlpsManager(apiKey: TestsConfig.kApiKey,
                                      baseURL: TestsConfig.kBaseUrl)
        var errorResponse: ErrorResponse?
        
        context("Alps Manager") {
            
            fit ("clear mobile devices") {
                alpsManager.mobileDevices.deleteAll()
                expect(alpsManager.mobileDevices.main).to(beNil())
                expect(alpsManager.mobileDevices.items).to(beEmpty())
            }
            
            beforeEach {
                errorResponse = nil
            }
            
            fit ("create main device") {
                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
                    alpsManager.createMainDevice { result in
                        if case .failure(let error) = result {
                            errorResponse = error
                        }
                        done()
                    }
                }
                expect(alpsManager.mobileDevices.main).toEventuallyNot(beNil())
                expect(alpsManager.mobileDevices.items).toEventuallyNot(beEmpty())
                expect(errorResponse?.errorMessage).toEventually(beNil())
            }
            
            fit ("create a publication") {
                let publication = Publication(topic: "Test Topic", range: 20, duration: 100, properties: properties)
                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
                    alpsManager.createPublication(publication: publication, completion: { (result) in
                        if case .failure(let error) = result {
                            errorResponse = error
                        }
                        done()
                    })
                }
                expect(alpsManager.publications.items).toEventuallyNot(beEmpty())
                expect(errorResponse?.errorMessage).toEventually(beNil())
            }
            
            fit ("create a subscription") {
                let subscription = Subscription(topic: "Test Topic", range: 20, duration: 100, selector: "test = 'true'")
                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
                    alpsManager.createSubscription(subscription: subscription, completion: { (result) in
                        if case .failure(let error) = result {
                            errorResponse = error
                        }
                    })
                    done()
                }
                expect(alpsManager.subscriptions.items).toEventuallyNot(beEmpty())
                expect(errorResponse?.errorMessage).toEventually(beNil())
            }
            
            fit ("recover state") {
                alpsManager = AlpsManager(apiKey: TestsConfig.kApiKey,
                                          baseURL: TestsConfig.kBaseUrl)
                expect(alpsManager.mobileDevices.main).toNot(beNil())
                expect(alpsManager.mobileDevices.items).toNot(beEmpty())
            }
            
            fit ("update location") {
                if let mainDeviceId = alpsManager.mobileDevices.main?.id {
                    alpsManager.locationUpdateManager.tryToSend(location: location, for: mainDeviceId)
                }
                expect(alpsManager.locationUpdateManager.lastLocation).toEventuallyNot(beNil())
            }
            
            fit ("get a match") {
                class MatchDelegate: AlpsManagerDelegate {
                    var onMatch: OnMatchClosure
                    init(_ onMatch: @escaping OnMatchClosure) {
                        self.onMatch = onMatch
                    }
                }
                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
                    guard let mainDevice = alpsManager.mobileDevices.main else { done(); return }
                    let matchDelegate = MatchDelegate { _, _ in done() }
                    alpsManager.delegates += matchDelegate
                    alpsManager.matchMonitor.startMonitoringFor(device: mainDevice)
                }
                expect(alpsManager.matchMonitor.deliveredMatches).toEventuallyNot(beEmpty())
            }
            
            fit ("delete device") {
                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
                    guard let mainDevice = alpsManager.mobileDevices.main else { done(); return }
                    alpsManager.matchMonitor.stopMonitoringFor(device: mainDevice)
                    alpsManager.mobileDevices.delete(item: mainDevice, completion: { (error) in
                        errorResponse = error
                        done()
                    })
                }
                expect(alpsManager.mobileDevices.main).toEventually(beNil())
                expect(errorResponse?.errorMessage).toEventually(beNil())
            }
            
        }
        
    }
}

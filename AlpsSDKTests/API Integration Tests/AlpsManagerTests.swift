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
    
    let kWaitTimeInterval = 10.0
    
    override func spec() {
        let apiKey = """
                    eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9
                    .eyJpc3MiOiJhbHBzIiwic3ViIjoiMmQwN2Q
                    xODQtZjU1OS00OGU5LTlmZTctNWJiNWQ0ZDQ
                    0Y2VhIiwiYXVkIjpbIlB1YmxpYyJdLCJuYmY
                    iOjE1MDk5NjYyMzMsImlhdCI6MTUwOTk2NjI
                    zMywianRpIjoiMSJ9.w8Zc6AK_fuCBde6oYd
                    MD7iot2waB8H6FzicK-IKdepN4cMFMQ9XH87
                    -hGndONQ8KmZ3-JkS8tcFmUUJVjg1K_Q
                    """
        let baseUrl = "http://146.148.15.57/v5"
        let properties = ["test": "true"]
        let location = Location(latitude: 10, longitude: 10, altitude: 10, horizontalAccuracy: 10, verticalAccuracy: 10)
        
        var alpsManager = AlpsManager(apiKey: apiKey,
                                      baseUrl: baseUrl
        )
        var errorResponse: ErrorResponse?
        
        context("Alps Manager") {
            beforeEach {
                errorResponse = nil
            }
            
            fit ("clear main device") {
                waitUntil(timeout: self.kWaitTimeInterval) { done in
                    guard let mainDevice = alpsManager.mobileDevices.main else { done(); return }
                    alpsManager.mobileDevices.delete(item: mainDevice, completion: { error in
                        errorResponse = error
                        done()
                    })
                }
                expect(alpsManager.mobileDevices.main).toEventually(beNil())
                expect(alpsManager.mobileDevices.items).toEventually(beEmpty())
                expect(errorResponse?.description).toEventually(beNil())
            }
            
            fit ("create main device") {
                waitUntil(timeout: self.kWaitTimeInterval) { done in
                    alpsManager.createMainDevice { _ in
                        done()
                    }
                }
                expect(alpsManager.mobileDevices.main).toEventuallyNot(beNil())
                expect(alpsManager.mobileDevices.items).toEventuallyNot(beEmpty())
                expect(errorResponse?.description).toEventually(beNil())
            }
            
            fit ("create a publication") {
                let publication = Publication(topic: "Test Topic", range: 20, duration: 100, properties: properties)
                alpsManager.createPublication(publication: publication)
                expect(alpsManager.publications.items).toEventuallyNot(beEmpty())
                expect(errorResponse).toEventually(beNil())
            }
            
            fit ("create a subscription") {
                let subscription = Subscription(topic: "Test Topic", range: 20, duration: 100, selector: "test = 'true'")
                alpsManager.createSubscription(subscription: subscription)
                expect(alpsManager.subscriptions.items).toEventuallyNot(beEmpty())
                expect(errorResponse).toEventually(beNil())
            }
            
            fit ("recover state") {
                alpsManager = AlpsManager(apiKey: apiKey,
                                          baseUrl: baseUrl)
                expect(alpsManager.mobileDevices.main).toNot(beNil())
                expect(alpsManager.mobileDevices.items).toNot(beEmpty())
            }
            
            fit ("update location") {
                guard let mainDeviceId = alpsManager.mobileDevices.main?.id else { return }
                alpsManager.locationUpdateManager.tryToSend(location: location, for: mainDeviceId)
                expect(alpsManager.locationUpdateManager.lastLocation).toEventuallyNot(beNil())
            }
            
            fit ("get a match") {
                waitUntil(timeout: self.kWaitTimeInterval) { done in
                    guard let mainDevice = alpsManager.mobileDevices.main else { done(); return }
                    alpsManager.matchMonitor.startMonitoringFor(device: mainDevice)
                    alpsManager.onMatch = { _, _ in
                        done()
                    }
                }
                expect(alpsManager.matchMonitor.deliveredMatches).toEventuallyNot(beEmpty())
            }
            
            fit ("delete device") {
                waitUntil(timeout: self.kWaitTimeInterval) { done in
                    guard let mainDevice = alpsManager.mobileDevices.main else { done(); return }
                    alpsManager.matchMonitor.stopMonitoringFor(device: mainDevice)
                    alpsManager.mobileDevices.delete(item: alpsManager.mobileDevices.main!, completion: { (_) in
                        done()
                    })
                }
                expect(alpsManager.mobileDevices.main).toEventually(beNil())
            }
            
        }
        
    }
}

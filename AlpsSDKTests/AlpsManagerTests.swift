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
        let alpsManager = AlpsManager(apiKey: "ba4b38d8-abbb-4947-b1de-ada6384e214c",
                                      baseUrl: "http://localhost:9000/v4")
        
        let properties = ["test": "true"]
        let location = Location(latitude: 10, longitude: 10, altitude: 10, horizontalAccuracy: 10, verticalAccuracy: 10)
        
        context("Alps Manager") {
            fit ("create main device") {
                alpsManager.createMainDevice()
                expect(alpsManager.mobileDevices.main).toEventuallyNot(beNil())
            }
            
            fit ("create a publication") {
                let items: [Publication]?
                let publication = Publication(topic: "Test Topic", range: 20, duration: 100, properties: properties)
                alpsManager.createPublication(publication: publication)
                expect(alpsManager.publications.items).toEventuallyNot(beEmpty())
            }
            
            fit ("create a subscription") {
                let subscription = Subscription(topic: "Test Topic", range: 20, duration: 100, selector: "test = 'true'")
                alpsManager.createSubscription(subscription: subscription)
                expect(alpsManager.subscriptions.items).toEventuallyNot(beEmpty())
            }
            
            fit ("update location") {
                guard let mainDeviceId = alpsManager.mobileDevices.main?.id else { return }
                alpsManager.locationUpdateManager.tryToSend(location: location, for: mainDeviceId)
                expect(alpsManager.locationUpdateManager.lastLocation).toEventuallyNot(beNil())
            }
            
            fit ("get a match") {
                waitUntil(timeout: self.kWaitTimeInterval) { done in
                    guard let mainDevice = alpsManager.mobileDevices.main else { return }
                    alpsManager.matchMonitor.startMonitoringFor(device: mainDevice)
                }
                expect(alpsManager.matchMonitor.deliveredMatches).toEventuallyNot(beEmpty())
            }
            
        }
        
    }
}

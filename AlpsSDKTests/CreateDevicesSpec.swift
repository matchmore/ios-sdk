//
//  CreateDevicesSpec.swift
//  AlpsSDKTests
//
//  Created by Maciej Burda on 18/10/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import AlpsSDK
@testable import Alps

class CreateDevicesSpec: QuickSpec {
    
    override func spec() {
        
        let manager = AlpsManager(apiKey: "ea0df90a-db0a-11e5-bd35-3bd106df139b")
        
        describe("Device Creation") {
            context("Asynchronus Pin Creation") {
                var createdPinDevice: Device?
                waitUntil(timeout: 10) { done in
                    manager.createPinDevice(
                        name: "Test Pin Device",
                        latitude: 12,
                        longitude: 12,
                        altitude: 12,
                        horizontalAccuracy: 10,
                        verticalAccuracy: 10,
                        completion: { pinDevice in
                            createdPinDevice = pinDevice
                            expect(createdPinDevice).toEventuallyNot(beNil())
                            done()
                    })
                }
            }
            context("Asynchronus Mobile Device Creation") {
                
                it("") {
                    expect(1).to(beGreaterThan(0))
                }
            }
            context("Asynchronus iBeacon Creation") {
                
                it("") {
                    expect(1).to(beGreaterThan(0))
                }
            }
        }
    }
}

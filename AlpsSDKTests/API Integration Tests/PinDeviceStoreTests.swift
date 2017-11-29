//
//  PinDeviceStoreTests.swift
//  AlpsSDKTests
//
//  Created by Maciej Burda on 18/10/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation

import Nimble
import Quick

@testable import AlpsSDK
@testable import Alps

class PinDeviceStoreTests: QuickSpec {
    
    override func spec() {
        TestsConfig.setupAPI()
        
        let pinDeviceStore = PinDeviceStore()
        var createdPinDeviceId: String = ""
        
        var errorResponse: ErrorResponse?
        
        context("pin device") {
            beforeEach {
                errorResponse = nil
            }
            fit ("create") {
                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
                    let pinDevice = PinDevice(
                        name: "Test Pin",
                        location: Location(
                            latitude: 12,
                            longitude: 12,
                            altitude: 12,
                            horizontalAccuracy: 10,
                            verticalAccuracy: 10
                        )
                    )
                    pinDeviceStore.create(item: pinDevice, 
                                               completion: { (result) in
                        switch result {
                        case .success(let pinDevice):
                            createdPinDeviceId = pinDevice.id ?? ""
                        case .failure(let error):
                            errorResponse = error
                        }
                        done()
                    })
                }
                expect(pinDeviceStore.items.first).toEventuallyNot(beNil())
                expect(errorResponse?.message).toEventually(beNil())
            }
            
            var readPinDevice: PinDevice?
            fit("read") {
                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
                    pinDeviceStore.find(byId: createdPinDeviceId,
                                             completion: { (result) in
                        switch result {
                        case .success(let pinDevice):
                            readPinDevice = pinDevice
                        case .failure(let error):
                            errorResponse = error
                        }
                        done()
                    })
                }
                expect(readPinDevice).toEventuallyNot(beNil())
                expect(errorResponse?.message).toEventually(beNil())
            }
            
            fit("delete") {
                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
                    if let readPinDevice = readPinDevice {
                        pinDeviceStore.delete(item: readPinDevice,
                                                   completion: { (error) in
                            errorResponse = error
                            done()
                        })
                    } else { done () }
                }
                expect(pinDeviceStore.items.first).toEventually(beNil())
                expect(errorResponse?.message).toEventually(beNil())
            }
        }
    }
}

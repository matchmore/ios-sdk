//
//  PinDeviceRepositoryTests.swift
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

class PinDeviceRepositoryTests: QuickSpec {
    
    override func spec() {
        TestsConfig.setupAPI()
        
        let pinDeviceRepository = PinDeviceRepository()
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
                    pinDeviceRepository.create(item: pinDevice, 
                                               completion: { (result) in
                        switch result {
                        case .success(let pinDevice):
                            createdPinDeviceId = pinDevice?.id ?? ""
                        case .failure(let error):
                            errorResponse = error
                        }
                        done()
                    })
                }
                expect(pinDeviceRepository.items.first).toEventuallyNot(beNil())
                expect(errorResponse?.message).toEventually(beNil())
            }
            
            var readPinDevice: PinDevice?
            fit("read") {
                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
                    pinDeviceRepository.find(byId: createdPinDeviceId,
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
                    pinDeviceRepository.delete(item: readPinDevice,
                                               completion: { (error) in
                        errorResponse = error
                        done()
                    })
                }
                expect(pinDeviceRepository.items.first).toEventually(beNil())
                expect(errorResponse?.message).toEventually(beNil())
            }
        }
    }
}

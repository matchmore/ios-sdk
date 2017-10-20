//
//  PinDeviceAsyncRepoTests.swift
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

class PinDeviceAsyncRepoTests: QuickSpec {
    
    func setupAPI() {
        let headers = [
            "api-key": "ee17b945-2dca-4d93-b3b4-75e4e9a007d2",
            "Content-Type": "application/json",
            ]
        AlpsAPI.customHeaders = headers
        AlpsAPI.basePath = "http://localhost:9000/v5"
    }
    
    override func spec() {
        setupAPI()
        let pinDeviceAsyncRepo = PinDeviceAsyncRepo()
        
        describe("pin device") {
            context("create new") {
                fit ("async request") {
                    var createdPinDevice: PinDevice?
                    waitUntil(timeout: 10) { done in
                        let pinDevice = PinDevice(name: "Test Pin", location: Location(latitude: 12, longitude: 12, altitude: 12, horizontalAccuracy: 10, verticalAccuracy: 10))
                        pinDeviceAsyncRepo.create(item: pinDevice, completion: { (result) in
                            if case let .success(pinDevice) = result {
                                createdPinDevice = pinDevice
                            }
                            done()
                        })
                    }
                    expect(createdPinDevice).toEventuallyNot(beNil())
                }
            }
        }
    }
}

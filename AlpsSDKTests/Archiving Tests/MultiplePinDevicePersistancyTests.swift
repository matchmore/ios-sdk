//
//  MultiplePinDevicePersistancyTests.swift
//  AlpsSDKTests
//
//  Created by Maciej Burda on 02/11/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import AlpsSDK

class MultiplePinDevicePersistancyTests: QuickSpec {
    
    override func spec() {
        let fileName = "TestPinDeviceFile"
        let archiver = NSKeyedArchiver(forWritingWith: NSMutableData())
        let pinDevices = [
            PinDevice(name: "1", location: Location(latitude: 0, longitude: 0, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0)),
            PinDevice(name: "2", location: Location(latitude: 0, longitude: 0, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0)),
            PinDevice(name: "3", location: Location(latitude: 0, longitude: 0, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0)),
            PinDevice(name: "4", location: Location(latitude: 0, longitude: 0, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0))
        ]
        let encodablePinDevices = pinDevices.map { $0.encodablePinDevice }
        
        context("multiple pin device saving") {
            fit ("encoding") {
                archiver.encode(encodablePinDevices, forKey: "mobileDevice")
                expect(archiver.encodedData.count).to(beGreaterThan(0))
            }
            
            fit ("saving") {
                let success = PersistenceManager.save(object: encodablePinDevices, to: fileName)
                expect(success).to(beTrue())
            }
            
            var decodedPinDevices: [EncodablePinDevice]?
            fit ("reading") {
                decodedPinDevices = PersistenceManager.read(type: [EncodablePinDevice].self, from: fileName)
                expect(decodedPinDevices?.count).to(equal(4))
            }
            
            fit ("decoding") {
                let pinDevice = decodedPinDevices?.map { $0.object }.first
                expect(pinDevice??.name).to(equal("1"))
            }
        }
    }
}

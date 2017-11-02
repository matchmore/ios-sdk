//
//  MobileDeviceArchiveTest.swift
//  AlpsSDKTests
//
//  Created by Maciej Burda on 01/11/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Alps
@testable import AlpsSDK

class MobileDeviceArchiveTest: QuickSpec {

    override func spec() {
        let fileName = "TestMobileDevice"
        let archiver = NSKeyedArchiver(forWritingWith: NSMutableData())
        let mobileDevice = MobileDevice(name: "Test Archived Device", platform: "Test iOS", deviceToken: "None", location: nil)
        let encodableMobileDevice = mobileDevice.encodableMobileDevice
        var decodedMobileDevice: EncodableMobileDevice?
        context("mobile device saving") {
            fit ("encoding") {
                archiver.encode(encodableMobileDevice, forKey: "mobileDevice")
                expect(archiver.encodedData.count).to(beGreaterThan(0))
            }
            
            fit ("saving") {
                let success = PersistancyManager.save(object: encodableMobileDevice, to: fileName)
                expect(success).to(beTrue())
            }
            
            fit ("reading") {
                decodedMobileDevice = PersistancyManager.read(type: EncodableMobileDevice.self, from: fileName)
                expect(decodedMobileDevice).toNot(beNil())
            }
            
            fit ("decoding") {
                let mobileDevice = decodedMobileDevice?.object
                expect(mobileDevice?.name).to(equal("Test Archived Device"))
                expect(mobileDevice?.platform).to(equal("Test iOS"))
                expect(mobileDevice?.deviceToken).to(equal("None"))
            }
        }
    }
}

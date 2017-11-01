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
        context("mobile device saving") {
            fit ("archiving") {
                let mobileDevice = MobileDevice(name: "Test Archived Device", platform: "Test iOS", deviceToken: "None", location: nil)
                let encodedMobileDevice = EncodableMobileDevice(mobileDevice: mobileDevice)
                
                let archiver = NSKeyedArchiver(forWritingWith: NSMutableData())
                archiver.encode(encodedMobileDevice, forKey: "mobileDevice")
                
                let unarchiver = NSKeyedUnarchiver(forReadingWith: archiver.encodedData)
                let decodedMobileDevice = unarchiver.decodeObject(forKey: "mobileDevice") as? EncodableMobileDevice
                expect(decodedMobileDevice?.mobileDevice.name).to(equal("Test Archived Device"))
            }
        }
    }
}

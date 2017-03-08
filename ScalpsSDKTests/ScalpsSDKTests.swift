//
//  ScalpsTests.swift
//  ScalpsTests
//
//  Created by Rafal Kowalski on 22.09.16.
//  Copyright © 2016 Scalps. All rights reserved.
//

import Foundation
import XCTest
import Scalps
@testable import ScalpsSDK


class ScalpsSDKTests: XCTestCase {
    let apiKey = "74a239bc-c37e-11e6-b772-5b027714674d"
    // var scalps: ScalpsSDK

    override func setUp() {
        super.setUp()
        // scalps = ScalpsManager(apiKey: apiKey)
    }

    override func tearDown() {
        super.tearDown()
    }

    func test1CreateUser() {
        let scalps = ScalpsManager(apiKey: apiKey)
        let expectation = self.expectation(description: "CreateUser")

        scalps.createUser("Swift User 1") {
            (_ user) in
            XCTAssertNotNil(user, "Whoops, no user")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }


    func test2CreateDevice() {
        let scalps = ScalpsManager(apiKey: apiKey)
        let deviceExpectation = expectation(description: "CreateDevice")


        scalps.createUser("Swift User 2") {
            (_ user) in
            if let _ = user {
                scalps.createDevice(name: "iPhone 7", platform: "iOS 10.2",
                                    deviceToken: "870470ea-7a8e-11e6-b49b-5358f3beb662",
                                    latitude: 37.7858, longitude: -122.4064, altitude: 100,
                                    horizontalAccuracy: 5.0, verticalAccuracy: 5.0) {
                    (_ device) in
                    XCTAssertNotNil(device, "Whoops, no device")
                    deviceExpectation.fulfill()
                }
            }
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func test3CreatePublication() {
        let scalps = ScalpsManager(apiKey: apiKey)
        let publicationExpectation = expectation(description: "CreatePub")

        scalps.createUser("Swift User 3") {
            (_ user) in
            if user != nil {
                scalps.createDevice(name: "iPhone 7", platform: "iOS 10.2",
                                    deviceToken: "870470ea-7a8e-11e6-b49b-5358f3beb663",
                                    latitude: 37.7858, longitude: -122.4064, altitude: 100,
                                    horizontalAccuracy: 5.0, verticalAccuracy: 5.0) {
                    (_ device) in
                    if device != nil {
                        // FIXME: provide serialization to json string
                        let properties = ["mood": "'happy'"]
                        // let propertiesString = "{\"mood\": \"happy\"}"

                        scalps.createPublication(topic: "scalps-ios-test", range: 100.0,
                                                 duration: 0, properties: properties) {
                            (_ publication) in
                            XCTAssertNotNil(publication)
                            publicationExpectation.fulfill()
                        }
                    }
                }
            }
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func test4CreateSubscription() {
        let scalps = ScalpsManager(apiKey: apiKey)
        let subscriptionExpectation = expectation(description: "CreateSub")

        scalps.createUser("Swift User 4") {
            (_ user) in
            if user != nil {
                scalps.createDevice(name: "iPhone 7", platform: "iOS 10.2",
                                    deviceToken: "870470ea-7a8e-11e6-b49b-5358f3beb664",
                                    latitude: 37.7858, longitude: -122.4064, altitude: 100,
                                    horizontalAccuracy: 5.0, verticalAccuracy: 5.0) {
                    (_ device) in
                    if device != nil {
                        scalps.createSubscription(topic: "scalps-ios-test",
                                                  selector: "mood = 'happy'",
                                                  range: 100.0,
                                                  duration: 0) {
                            (_ subscription) in
                            XCTAssertNotNil(subscription)
                            subscriptionExpectation.fulfill()
                        }
                    }
                }
            }
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }


    func test5UpdateLocation() {
        let scalps = ScalpsManager(apiKey: apiKey)
        let locationExpectation = expectation(description: "UpdateLocation")

        scalps.createUser("Swift User 5") {
            (_ user) in
            if user != nil {
                scalps.createDevice(name: "iPhone 7", platform: "iOS 10.2",
                                    deviceToken: "870470ea-7a8e-11e6-b49b-5358f3beb665",
                                    latitude: 37.7858, longitude: -122.4064, altitude: 100,
                                    horizontalAccuracy: 5.0, verticalAccuracy: 5.0) {
                    (_ device) in
                    if let d = device {
                        _ = DeviceLocation(deviceId: d.deviceId!,
                                                         altitude: 0,
                                                         latitude: 37.785833999999994,
                                                         longitude: -122.406417)
                        scalps.updateLocation(latitude: 38.00, longitude: -123, altitude: 100,
                                              horizontalAccuracy: 5.0, verticalAccuracy: 5.0) {
                            (_ location) in
                            XCTAssertNotNil(location)
                            locationExpectation.fulfill()
                        }
                    }
                }
            }
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    /*
     // XXX: still not found a way to allow location updates from tests
     // http://stackoverflow.com/questions/40033185/how-to-access-calendar-camera-etc-from-tests
     func test6ContinouslyUpdatingLocation() {
     let scalps = ScalpsManager(apiKey: apiKey)
     let deviceTemplate = Device(name: "Scalps Test Device 5",
     platform: "iOS 9.3",
     deviceToken: "870470ea-7a8e-11e6-b49b-5358f3beb665")

     let locationExpectation = expectation(description: "UpdateLocation")

     scalps.createUser("Swift User 5") {
     (_ user) in
     if let u = user {
     // scalps.createDevice(deviceTemplate, for: u) {
     scalps.createDevice(deviceTemplate) {
     (_ device) in
     if let d = device {
     scalps.startUpdatingLocation()
     /*
     let newLocation = DeviceLocation(deviceId: d.deviceId!,
     altitude: 0,
     latitude: 37.785833999999994,
     longitude: -122.406417)
     scalps.updateLocation(newLocation, for: u, on: d) {
     (_ location) in
     XCTAssertNotNil(location)
     locationExpectation.fulfill()
     }
     */
     }
     }
     }
     }

     waitForExpectations(timeout: 5.0, handler: nil)
     scalps.stopUpdatingLocation()
     }
     */
}

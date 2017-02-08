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

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
            if let u = user {
            scalps.createDevice(u.userId!, name: "iPhone 7", platform: "iOS 10.2",
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

    /*
    func test3CreatePublication() {
        let scalps = ScalpsManager(apiKey: apiKey)
        let deviceTemplate = Device(name: "Scalps Test Device 3",
                                    platform: "iOS 9.3",
                                    deviceToken: "870470ea-7a8e-11e6-b49b-5358f3beb663")

        let publicationExpectation = expectation(description: "CreatePub")

        scalps.createUser("Swift User 3") {
            (_ user) in
            if let u = user {
                // scalps.createDevice(deviceTemplate, for: u) {
                scalps.createDevice(deviceTemplate) {
                    (_ device) in
                    if let d = device {
                        let location = DeviceLocation(deviceId: d.deviceId!,
                                                      altitude: 0,
                                                      latitude: 37.785833999999994,
                                                      longitude: -122.406417)
                        let payload = Payload(dictionary: ["mood": "happy"])
                        let publicationTemplate = Publication(topic: "scalps-ios-test",
                                                              range: 100.0,
                                                              duration: 0,
                                                              location: location,
                                                              payload: payload)

                        scalps.createPublication(publicationTemplate, for: u, on: d) {
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
        let deviceTemplate = Device(name: "Scalps Test Device 4",
                                    platform: "iOS 9.3",
                                    deviceToken: "870470ea-7a8e-11e6-b49b-5358f3beb664")

        let subscriptionExpectation = expectation(description: "CreateSub")

        scalps.createUser("Swift User 4") {
            (_ user) in
            if let u = user {
                // scalps.createDevice(deviceTemplate, for: u) {
                scalps.createDevice(deviceTemplate) {
                    (_ device) in
                    if let d = device {
                        let location = DeviceLocation(deviceId: d.deviceId!,
                                                      altitude: 0,
                                                      latitude: 37.785833999999994,
                                                      longitude: -122.406417)
                        let selector = "'mood' = 'happy'"
                        let subscriptionTemplate = Subscription(topic: "scalps-ios-test",
                                                                range: 100.0,
                                                                duration: 0,
                                                                location: location,
                                                                selector: selector)

                        scalps.createSubscription(subscriptionTemplate, for: u, on: d) {
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
        let deviceTemplate = Device(name: "Scalps Test Device 6",
                                    platform: "iOS 9.3",
                                    deviceToken: "870470ea-7a8e-11e6-b49b-5358f3beb666")

        let locationExpectation = expectation(description: "UpdateLocation")

        scalps.createUser("Swift User 6") {
            (_ user) in
            if let u = user {
                // scalps.createDevice(deviceTemplate, for: u) {
                scalps.createDevice(deviceTemplate) {
                    (_ device) in
                    if let d = device {
                        let newLocation = DeviceLocation(deviceId: d.deviceId!,
                                                         altitude: 0,
                                                         latitude: 37.785833999999994,
                                                         longitude: -122.406417)
                        scalps.updateLocation(newLocation, for: u, on: d) {
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

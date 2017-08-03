//
//  AlpsTests.swift
//  AlpsTests
//
//  Created by Rafal Kowalski on 22.09.16.
//  Copyright © 2016 Alps. All rights reserved.
//

import Foundation
import XCTest
import Alps
@testable import AlpsSDK


class AlpsSDKTests: XCTestCase {
    let apiKey = "ea0df90a-db0a-11e5-bd35-3bd106df139b"
    // var alps: AlpsSDK

    override func setUp() {
        super.setUp()
        // alps = AlpsManager(apiKey: apiKey)
    }

    override func tearDown() {
        super.tearDown()
    }

    func test1CreateUser() {
        let alps = AlpsManager(apiKey: apiKey)
        let expectation = self.expectation(description: "CreateUser")

        alps.createUser("Swift User 1") {
            (_ user) in
            XCTAssertNotNil(user, "Whoops, no user")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }


    func test2CreateDevice() {
        let alps = AlpsManager(apiKey: apiKey)
        let deviceExpectation = expectation(description: "CreateDevice")


        alps.createUser("Swift User 2") {
            (_ user) in
            if let _ = user {
                alps.createDevice(name: "iPhone 7", platform: "iOS 10.2",
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
        let alps = AlpsManager(apiKey: apiKey)
        let publicationExpectation = expectation(description: "CreatePub")

        alps.createUser("Swift User 3") {
            (_ user) in
            if user != nil {
                alps.createDevice(name: "iPhone 7", platform: "iOS 10.2",
                                    deviceToken: "870470ea-7a8e-11e6-b49b-5358f3beb663",
                                    latitude: 37.7858, longitude: -122.4064, altitude: 100,
                                    horizontalAccuracy: 5.0, verticalAccuracy: 5.0) {
                    (_ device) in
                    if device != nil {
                        // FIXME: provide serialization to json string
                        let properties = ["mood": "'happy'"]
                        // let propertiesString = "{\"mood\": \"happy\"}"

                        alps.createPublication(topic: "alps-ios-test", range: 100.0,
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
        let alps = AlpsManager(apiKey: apiKey)
        let subscriptionExpectation = expectation(description: "CreateSub")

        alps.createUser("Swift User 4") {
            (_ user) in
            if user != nil {
                alps.createDevice(name: "iPhone 7", platform: "iOS 10.2",
                                    deviceToken: "870470ea-7a8e-11e6-b49b-5358f3beb664",
                                    latitude: 37.7858, longitude: -122.4064, altitude: 100,
                                    horizontalAccuracy: 5.0, verticalAccuracy: 5.0) {
                    (_ device) in
                    if device != nil {
                        alps.createSubscription(topic: "alps-ios-test",
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
        let alps = AlpsManager(apiKey: apiKey)
        let locationExpectation = expectation(description: "UpdateLocation")

        alps.createUser("Swift User 5") {
            (_ user) in
            if user != nil {
                alps.createDevice(name: "iPhone 7", platform: "iOS 10.2",
                                    deviceToken: "870470ea-7a8e-11e6-b49b-5358f3beb665",
                                    latitude: 37.7858, longitude: -122.4064, altitude: 100,
                                    horizontalAccuracy: 5.0, verticalAccuracy: 5.0) {
                    (_ device) in
                    if let d = device {
                        _ = DeviceLocation(deviceId: d.deviceId!,
                                                         altitude: 0,
                                                         latitude: 37.785833999999994,
                                                         longitude: -122.406417)
                        alps.updateLocation(latitude: 38.00, longitude: -123, altitude: 100,
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
    
    // This test should implement asynchronous call to get the beacons and construct a beacon object
    func test7CreateBeacons() {
        // 1. given
        XCTAssertNotNil(DeviceBis.init(beaconName: "beacon1 - rose", uuid: UUID.init(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, major: 21978, minor: 59907))
    }
    
    func test6GetBeacons() {
        let alps = AlpsManager(apiKey: apiKey)
        XCTAssertNotNil(alps.beacons)
        XCTAssertEqual(alps.beacons.count, 3, "Number of Dummy beacons should be 3.")
    }

    /*
     // XXX: still not found a way to allow location updates from tests
     // http://stackoverflow.com/questions/40033185/how-to-access-calendar-camera-etc-from-tests
     func test6ContinouslyUpdatingLocation() {
     let alps = AlpsManager(apiKey: apiKey)
     let deviceTemplate = Device(name: "Alps Test Device 5",
     platform: "iOS 9.3",
     deviceToken: "870470ea-7a8e-11e6-b49b-5358f3beb665")

     let locationExpectation = expectation(description: "UpdateLocation")

     alps.createUser("Swift User 5") {
     (_ user) in
     if let u = user {
     // alps.createDevice(deviceTemplate, for: u) {
     alps.createDevice(deviceTemplate) {
     (_ device) in
     if let d = device {
     alps.startUpdatingLocation()
     /*
     let newLocation = DeviceLocation(deviceId: d.deviceId!,
     altitude: 0,
     latitude: 37.785833999999994,
     longitude: -122.406417)
     alps.updateLocation(newLocation, for: u, on: d) {
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
     alps.stopUpdatingLocation()
     }
     */
}

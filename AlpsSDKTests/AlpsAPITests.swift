//
//  AlpsAPITests.swift
//  AlpsAPITests
//
//  Created by Rafal Kowalski on 01/09/16.
//  Copyright © 2016 Alps. All rights reserved.
//

import XCTest
@testable import Alps
import Alamofire

class AlpsAPITests: XCTestCase {
    let headers = [
        "user-agent": "iOS 9.3.0",
        "api-key": "ea0df90a-db0a-11e5-bd35-3bd106df139b",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json, text/plain"
    ]

    let now = { Int64(Date().timeIntervalSince1970 * 1000) }

    override func setUp() {
        super.setUp()
        // AlpsAPI.basePath = "http://localhost:9000"
        // AlpsAPI.basePath = "http://api.matchmore.io/v03"
        AlpsAPI.customHeaders = headers
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func createUser() -> User? {
        var createdUser: User?
        let expectation = self.expectation(description: "CreateUser")

        let _ = Alps.UsersAPI.createUser(name: "Alps User 1", completion: {
            (user, error) -> Void in

            XCTAssertNil(error, "Whoops, error \(error)")
            createdUser = user
            expectation.fulfill()
        })

        waitForExpectations(timeout: 5.0, handler: nil)

        return createdUser
    }

    func createDevice(_ user: User) -> Device? {
        let deviceExpectation = expectation(description: "CreateDevice")

        var createdDevice: Device?

        let _ = Alps.UserAPI.createDevice(userId: user.userId!, name: "Alps iPhone 7", platform: "iOS 9.3",
                                            deviceToken: "870470ea-7a8e-11e6-b49b-5358f3beb662",
                                            latitude: 37.7858, longitude: 122.4064, altitude: 200.0,
                                            horizontalAccuracy: 5.0, verticalAccuracy: 5.0) {
            (device, error) -> Void in

            XCTAssertNil(error, "Whoops, error \(error)")
            createdDevice = device
            deviceExpectation.fulfill()
        }

        waitForExpectations(timeout: 5.0, handler: nil)

        return createdDevice
    }

    func createPublication(_ user: User, device: Device) -> Publication? {
        var createdPublication: Publication?

        let pubExpectation = expectation(description: "CreatePub")

        // let properties = Properties(dictionaryLiteral: ("role", "'developer'"))
        let properties = ["role": "'developer'"]

        let _ = Alps.DeviceAPI.createPublication(userId: user.userId!, deviceId: device.deviceId!,
                                                   topic: "alps-test", range: 100.0, duration: 0.0,
                                                   properties: properties) {
            (publication, error) -> Void in

            XCTAssertNil(error, "Whoops, error \(error)")
            createdPublication = publication
            pubExpectation.fulfill()
        }

        waitForExpectations(timeout: 5.0, handler: nil)

        return createdPublication
    }

    func createSubscription(_ user: User, device: Device) -> Subscription? {
        var createdSubscription: Subscription?

        let subExpectation = expectation(description: "CreateSub")
        let selector = "role = 'developer'"

        let _ = Alps.DeviceAPI.createSubscription(userId: user.userId!, deviceId: device.deviceId!,
                                                    topic: "alps-test", selector: selector, range: 100.0,
                                                    duration: 0.0) {
            (subscription, error) -> Void in

                                                        XCTAssertNil(error, "Whoops, error \(error)")
                                                        createdSubscription = subscription
                                                        subExpectation.fulfill()
        }

        waitForExpectations(timeout: 5.0, handler: nil)

        return createdSubscription
    }

    func createLocation(_ user: User, device: Device) -> DeviceLocation? {
        let locExpectation = expectation(description: "CreateLoc")
        var createdLocation: DeviceLocation?

        let _ = Alps.DeviceAPI.createLocation(userId: user.userId!, deviceId: device.deviceId!,
                                                latitude: 37.7858, longitude: -122.4064, altitude: 20.0,
                                                horizontalAccuracy: 5.0, verticalAccuracy: 5.0) {
            (location, error) -> Void in

            XCTAssertNil(error, "Whoops, error \(error)")
            createdLocation = location
            locExpectation.fulfill()
        }

        waitForExpectations(timeout: 5.0, handler: nil)

        return createdLocation
    }

    func getMatches(_ user: User, device: Device) -> [Match]? {
        let matchExpectation = expectation(description: "GetMatches")
        var gotMatches: [Match]?

        let _ = Alps.DeviceAPI.getMatches(userId: user.userId!, deviceId: device.deviceId!) {
            (matches, error) -> Void in

            XCTAssertNil(error, "Whoops, error \(error)")
            gotMatches = matches
            matchExpectation.fulfill()
        }

        waitForExpectations(timeout: 5.0, handler: nil)

        return gotMatches
    }

    func test1Alamofire() {
        let expectation = self.expectation(description: "Alamofire")

        Alamofire.request(AlpsAPI.basePath.appending("/ping"), headers: headers)
            .validate(statusCode: 200..<300)
            .responseString { response in
                print("Success: \(response.result.isSuccess)")
                XCTAssert(response.result.isSuccess, "Status code not 200")
                print("Response String: \(response.result.value)")

                expectation.fulfill()
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }


    func test2CreateUser() {
        let user = createUser()
        XCTAssertNotNil(user)
    }

    func test3CreateDevice() {
        if let user = createUser() {
            let device = createDevice(user)
            XCTAssertNotNil(device)
        }
    }

    func test4CreatePublication() {
        if let user = createUser() {
            if let device = createDevice(user) {
                let publication = createPublication(user, device: device)
                XCTAssertNotNil(publication)
            }
        }
    }

    func test5CreateSubscription() {
        if let user = createUser() {
            if let device = createDevice(user) {
                let subscription = createSubscription(user, device: device)
                XCTAssertNotNil(subscription)
            }
        }
    }

    func test6CreateLocation() {
        if let user = createUser() {
            if let device = createDevice(user) {
                let location = createLocation(user, device: device)
                XCTAssertNotNil(location)
            }
        }
    }

    func test7GetMatches() {
        if let user = createUser() {
            if let device = createDevice(user) {
                let matches = getMatches(user, device: device)
                XCTAssertNotNil(matches)
            }
        }
    }
}

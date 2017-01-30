//
//  ScalpsAPITests.swift
//  ScalpsAPITests
//
//  Created by Rafal Kowalski on 01/09/16.
//  Copyright © 2016 Scalps. All rights reserved.
//

import XCTest
@testable import Scalps
// import ScalpsSDK
import Alamofire

class ScalpsAPITests: XCTestCase {
    let headers = [
        "user-agent": "iOS 9.3.0",
        "api-key": "833ec460-c09d-11e6-9bb0-cfb02086c30d",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json, text/plain"
    ]

    let now = { Int64(Date().timeIntervalSince1970 * 1000) }

    override func setUp() {
        super.setUp()
        ScalpsAPI.basePath = "http://localhost:9000"
        ScalpsAPI.customHeaders = headers
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func createUser() -> User? {
        var createdUser: User?
        let expectation = self.expectation(description: "CreateUser")

        // let userTemplate = User()
        // userTemplate.name = "Scalps User 1"
        // XXX: Old version using unbacked user ;-)
        // let userTemplate = User(name: userName)
        // let _ = Scalps.UsersAPI.createUser(user: userTemplate, completion: {

        let userName = "Scalps User 1"
        let _ = Scalps.UsersAPI.createUser(name: userName, completion: {
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

        let _ = Scalps.UserAPI.createDevice(userId: user.userId!, name: "Scalps iPhone 7", platform: "iOS 9.3",
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
        // let dictionary = ["mood": "happy"]

        let _ = Scalps.DeviceAPI.createPublication(userId: user.userId!, deviceId: device.deviceId!, topic: "scalps-test", range: 100, duration: 0, properties: "") {
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

        let pubExpectation = expectation(description: "CreateSub")
        // let selector = "'mood' = 'happy'"
 
        let _ = Scalps.DeviceAPI.createSubscription(userId: user.userId!, deviceId: device.deviceId!, topic: "scalps-test", selector: "", range: 100, duration: 0) {
                                                            (subscription, error) -> Void in

                                                            XCTAssertNil(error, "Whoops, error \(error)")
                                                            createdSubscription = subscription
                                                            pubExpectation.fulfill()
        }

        waitForExpectations(timeout: 5.0, handler: nil)

        return createdSubscription
    }

    func createLocation(_ user: User, device: Device) -> DeviceLocation? {
        let locExpectation = expectation(description: "CreateLoc")
        var createdLocation: DeviceLocation?

        let _ = Scalps.DeviceAPI.createLocation(userId: user.userId!, deviceId: device.deviceId!, latitude: 37.7858, longitude: -122.4064, altitude: 20,horizontalAccuracy: 5, verticalAccuracy: 5) {
            (location, error) -> Void in
            
            XCTAssertNil(error, "Whoops, error \(error)")
            createdLocation = location
            locExpectation.fulfill()
        }

        waitForExpectations(timeout: 5.0, handler: nil)

        return createdLocation
    }
    
    func test1Alamofire() {
        let expectation = self.expectation(description: "Alamofire")

        Alamofire.request("http://localhost:9000/ping", headers: headers)
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
}

//
//  AlpsAPITests.swift
//  AlpsAPITests
//
//  Created by Rafal Kowalski on 01/09/16.
//  Copyright © 2016 Alps. All rights reserved.
//

import XCTest
@testable import Alps
@testable import AlpsSDK
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
        let user = User.init(name: "Alps User 1")
        let _ = Alps.UsersAPI.createUser(user: user, completion: {
            (user, error) -> Void in

            
            createdUser = user
            XCTAssertNil(error, "Whoops, error \(String(describing: error))")
            expectation.fulfill()
        })

        waitForExpectations(timeout: 5.0, handler: nil)

        return createdUser
    }
    
    func createMobileDevice(_ user: User) -> MobileDevice? {
        let deviceExpectation = expectation(description: "CreateMobileDevice")
        
        var createdDevice: MobileDevice?
        let location = Location.init(latitude: 37.7858, longitude: 122.4064, altitude: 200.0, horizontalAccuracy: 5.0, verticalAccuracy: 5.0)
        let mobileDevice = MobileDevice.init(name: "Alps iPhone 7", platform: "iOS 9.3",deviceToken: "870470ea-7a8e-11e6-b49b-5358f3beb662", location: location)
        let _ = Alps.UserAPI.createDevice(userId: user.id!, device: mobileDevice) {
                                            (device, error) -> Void in
                                            
                                            XCTAssertNil(error, "Whoops, error \(String(describing: error))")
                                            createdDevice = device as? MobileDevice
                                            deviceExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
        
        return createdDevice
    }
    
    func createPinDevice(_ user: User) -> PinDevice? {
        let deviceExpectation = expectation(description: "CreatePinDevice")
        
        var createdDevice: PinDevice?
        let location = Location.init(latitude: 37.7858, longitude: 122.4064, altitude: 200.0, horizontalAccuracy: 5.0, verticalAccuracy: 5.0)
        let pinDevice = PinDevice.init(name: "Alps iPhone 7", location: location)
        let _ = Alps.UserAPI.createDevice(userId: user.id!, device: pinDevice) {
                                                    (device, error) -> Void in
            
                                                    XCTAssertNil(error, "Whoops, error \(String(describing: error))")
                                                    createdDevice = device as? PinDevice
                                                    deviceExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
        
        return createdDevice
    }
    
    func createBeaconDevice(_ user: User) -> IBeaconDevice? {
        let deviceExpectation = expectation(description: "CreateBeaconDevice")
        
        var createdDevice: IBeaconDevice?
        let iBeaconDevice = IBeaconDevice.init(name: "Alps iPhone 7", uuid: "B9407F30-F5F8-466E-AFF9-25556B57FE6D", major: 10, minor: 10)
        let _ = Alps.UserAPI.createDevice(userId: user.id!, device: iBeaconDevice) {
                                                (device, error) -> Void in
                                                
                                                XCTAssertNil(error, "Whoops, error \(String(describing: error))")
                                                createdDevice = device as? IBeaconDevice
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

        let publication = Publication.init(deviceId: device.id!, topic: "alps-test", range: 100.0, duration: 0.0, properties: properties)
        let _ = Alps.DeviceAPI.createPublication(userId: user.id!, deviceId: device.id!, publication: publication) {
            (publication, error) -> Void in

            XCTAssertNil(error, "Whoops, error \(String(describing: error))")
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

        let subscription = Subscription.init(deviceId: device.id!, topic: "alps-test", range: 100.0, duration: 0.0, selector: selector)
        let _ = Alps.DeviceAPI.createSubscription(userId: user.id!, deviceId: device.id!, subscription: subscription) {
                                                    (subscription, error) -> Void in
                                                        XCTAssertNil(error, "Whoops, error \(String(describing: error))")
                                                        createdSubscription = subscription
                                                        subExpectation.fulfill()
        }

        waitForExpectations(timeout: 5.0, handler: nil)

        return createdSubscription
    }

    func createLocation(_ user: User, device: Device) -> DeviceLocation? {
        let locExpectation = expectation(description: "CreateLoc")
        var createdLocation: DeviceLocation?

        let location = Location.init(latitude: 37.7858, longitude: -122.4064, altitude: 20.0,horizontalAccuracy: 5.0, verticalAccuracy: 5.0)
        let _ = Alps.DeviceAPI.createLocation(userId: user.id!, deviceId: device.id!, location: location) {
                (location, error) -> Void in
                    XCTAssertNil(error, "Whoops, error \(String(describing: error))")
                    createdLocation = location
                    locExpectation.fulfill()
        }

        waitForExpectations(timeout: 5.0, handler: nil)

        return createdLocation
    }

    func getMatches(_ user: User, device: Device) -> [Match]? {
        let matchExpectation = expectation(description: "GetMatches")
        var gotMatches: [Match]?

        let _ = Alps.DeviceAPI.getMatches(userId: user.id!, deviceId: device.id!) {
            (matches, error) -> Void in

            XCTAssertNil(error, "Whoops, error \(String(describing: error))")
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
                print("Response String: \(String(describing: response.result.value))")

                expectation.fulfill()
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }


    func test2CreateUser() {
        let user = createUser()
        XCTAssertNotNil(user)
    }
    
    func test3CreateMobileDevice() {
        if let user = createUser() {
            let device = createMobileDevice(user)
            XCTAssertNotNil(device)
        }
    }
    
    func test4CreatePinDevice() {
        if let user = createUser() {
            let device = createPinDevice(user)
            XCTAssertNotNil(device)
        }
    }
    
    func test5CreateBeaconDevice() {
        if let user = createUser() {
            let device = createBeaconDevice(user)
            XCTAssertNotNil(device)
        }
    }

    func test6CreatePublication() {
        if let user = createUser() {
            if let device = createMobileDevice(user) {
                let publication = createPublication(user, device: device)
                XCTAssertNotNil(publication)
            }
        }
    }

    func test7CreateSubscription() {
        if let user = createUser() {
            if let device = createMobileDevice(user) {
                let subscription = createSubscription(user, device: device)
                XCTAssertNotNil(subscription)
            }
        }
    }

    func test8CreateLocation() {
        if let user = createUser() {
            if let device = createMobileDevice(user) {
                let location = createLocation(user, device: device)
                XCTAssertNotNil(location)
            }
        }
    }

    func test9GetMatches() {
        if let user = createUser() {
            if let device = createMobileDevice(user) {
                let matches = getMatches(user, device: device)
                XCTAssertNotNil(matches)
            }
        }
    }
}

//
//  BeaconRepositoryTests.swift
//  AlpsSDKTests
//
//  Created by Maciej Burda on 26/10/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Alps
@testable import AlpsSDK

class BeaconRepositoryTests: QuickSpec {
    
    func setupAPI() {
        let headers = [
            "api-key": """
            eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9
            .eyJpc3MiOiJhbHBzIiwic3ViIjoiMmQwN2Q
            xODQtZjU1OS00OGU5LTlmZTctNWJiNWQ0ZDQ
            0Y2VhIiwiYXVkIjpbIlB1YmxpYyJdLCJuYmY
            iOjE1MDk5NjYyMzMsImlhdCI6MTUwOTk2NjI
            zMywianRpIjoiMSJ9.w8Zc6AK_fuCBde6oYd
            MD7iot2waB8H6FzicK-IKdepN4cMFMQ9XH87
            -hGndONQ8KmZ3-JkS8tcFmUUJVjg1K_Q
            """,
            "Content-Type": "application/json"
        ]
        AlpsAPI.customHeaders = headers
        AlpsAPI.basePath = "http://146.148.15.57/v5"
    }
    
    let kWaitTimeInterval = 10.0
    
    override func spec() {
        setupAPI()
        let beaconRepository = BeaconRepository()
        
        context("beacons") {
            fit ("get non existing") {
                var nonExistringBeacon: IBeaconTriple?
                beaconRepository.find(byId: "NONEXISTING_TEST_ID", completion: { (result) in
                    if case let .success(iBeacon) = result {
                        nonExistringBeacon = iBeacon
                    }
                })
                expect(nonExistringBeacon).toEventually(beNil())
            }
        }
    }
}

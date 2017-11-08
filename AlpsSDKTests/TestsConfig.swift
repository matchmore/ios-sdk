//
//  TestsConfig.swift
//  AlpsSDKTests
//
//  Created by Maciej Burda on 07/11/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Alps

class TestsConfig {
    // swiftlint:disable:next line_length
    static let kApiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhbHBzIiwic3ViIjoiNWQxYTM2NjgtZjZmYy00Y2MyLWJlYTgtYWNiMzM1M2MyY2U3IiwiYXVkIjpbIlB1YmxpYyJdLCJuYmYiOjE1MDk5ODQyMTQsImlhdCI6MTUwOTk4NDIxNCwianRpIjoiMSJ9.1JxzbbB91Jq2HvxYWjazrKeRXCEJxcc_XU2Tk1j0xNARwwGlS-JWAto8wHH_P6ASQ-7VzIvYv1wUoV8XAG-LVQ"
    static let kBaseUrl = "http://146.148.15.57/v5"
    static let kWaitTimeInterval = 10.0
    
    class func setupAPI() {
        let headers = [
            "api-key": kApiKey,
            "Content-Type": "application/json"
        ]
        AlpsAPI.customHeaders = headers
        AlpsAPI.basePath = kBaseUrl
    }
}

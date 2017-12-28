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
    static let kApiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhbHBzIiwic3ViIjoiZWRhMzQwYTAtNmUwOC00MWJhLWE3ZTEtMzU0YjExNTRkZGE4IiwiYXVkIjpbIlB1YmxpYyJdLCJuYmYiOjE1MTMxNjg1NzksImlhdCI6MTUxMzE2ODU3OSwianRpIjoiMSJ9.RLtv2x80KBaxtt4ADdo78MO-V3cMWvcadje7wi5QDiWS3vkKEeiBabzHRPgVrjvwDqHK6KbJ0cATayAZnWT78w"
    static let kWorldId = "eda340a0-6e08-41ba-a7e1-354b1154dda8"
    static let kBaseUrl = "http://35.201.116.232/v5"
    static let kWaitTimeInterval = 30.0
    
    class func setupAPI() {
        let headers = [
            "api-key": kApiKey,
            "Content-Type": "application/json"
        ]
        AlpsAPI.customHeaders = headers
        AlpsAPI.basePath = kBaseUrl
    }
}

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
    static let kApiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhbHBzIiwic3ViIjoiOTYzMjE5N2YtMDdjOC00Yzg0LWE4NzUtZGVjOGJmNDM3Mjg1IiwiYXVkIjpbIlB1YmxpYyJdLCJuYmYiOjE1MTExODI3MzQsImlhdCI6MTUxMTE4MjczNCwianRpIjoiMSJ9.JW8GFVI5NO2AQXjIAVefcJ14DtOkjL7S_R9ewZtlg7PAsHX0wrne8bV_tRpJD75JgE3Dt-tSeDakV-UlYZFSPA"
    static let kBaseUrl = "https://api.matchmore.io/v5"
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

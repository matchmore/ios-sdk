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
    static let kApiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhbHBzIiwic3ViIjoiMDBkNDcyYjYtNTFlNy00YTUwLWExYWMtMGJjMTYyNTM1OGRlIiwiYXVkIjpbIlB1YmxpYyJdLCJuYmYiOjE1MTA3Njc0MzgsImlhdCI6MTUxMDc2NzQzOCwianRpIjoiMTAifQ.nt5yC0ceGojh4jSbqfFMA4mciALC1NmrBUcLNlbvI8UL5KekOJFiO0bxUceTOEpqZGRglRz4rIFB40qFwP3aPA"
    static let kBaseUrl = "http://api.matchmore.io/v5"
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

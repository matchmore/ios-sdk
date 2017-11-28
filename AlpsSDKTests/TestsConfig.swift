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
    static let kApiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhbHBzIiwic3ViIjoiOTYzMjE5N2YtMDdjOC00Yzg0LWE4NzUtZGVjOGJmNDM3Mjg1IiwiYXVkIjpbIlB1YmxpYyJdLCJuYmYiOjE1MTE4NjMzNDUsImlhdCI6MTUxMTg2MzM0NSwianRpIjoiNCJ9.IXEclo2C_4IWh2V1F6B95O-Xo9LSQ_rcVhr9_Fg428z4gLhPLnMeXdnVy6f_RJObPC3in5J2ca7y19H2BNMWyg"
    static let kWorldId = "9632197f-07c8-4c84-a875-dec8bf437285"
    static let kBaseUrl = "https://api.matchmore.io/v5"
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

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
    static let kApiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhbHBzIiwic3ViIjoiYzY0YmE1NGEtNDg2ZS00MmZmLWIxOGItNzhiNWVjZjdmNTU1IiwiYXVkIjpbIlB1YmxpYyJdLCJuYmYiOjE1MTA4NDA0ODgsImlhdCI6MTUxMDg0MDQ4OCwianRpIjoiMSJ9.xtnq_qrB3GS53HLdWTRKp0by1Cyg4Vdojzgt9nqXG9t72m6I3-gq1_r6x7lOdHE9BJiE-mijOKVtMXIxESCjpg"
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

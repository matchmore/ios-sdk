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
    static let kApiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhbHBzIiwic3ViIjoiY2VlZjllZTQtNTQ1Mi00Yjg3LTg3OTQtMTQwODFmN2ZkMmYyIiwiYXVkIjpbIlB1YmxpYyJdLCJuYmYiOjE1MTY3MjU0MjMsImlhdCI6MTUxNjcyNTQyMywianRpIjoiMSJ9.ACB9sN3nmaGTJCds67grUInnVvUWuI2xEijNblap0eC6SEprb3qotp6rx-zE_qRAlx_pXFksf8JIZYqgwhNuWQ"
    static let kWorldId = "ceef9ee4-5452-4b87-8794-14081f7fd2f2"
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

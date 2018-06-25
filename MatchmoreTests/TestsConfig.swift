//
//  TestsConfig.swift
//  MatchmoreTests
//
//  Created by Maciej Burda on 07/11/2017.
//  Copyright © 2017 Matchmore. All rights reserved.
//

import CoreLocation
@testable import Matchmore

class TestsConfig {
    // swiftlint:disable:next line_length
    static let kApiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhbHBzIiwic3ViIjoiYWYwOGExMDktNGY4Ni00NTEyLThhMTQtNzcwZjIzZDllY2YxIiwiYXVkIjpbIlB1YmxpYyJdLCJuYmYiOjE1MTg2MjIyODgsImlhdCI6MTUxODYyMjI4OCwianRpIjoiMSJ9.IgS_9CJguACM7YtREYHgcYmb58yeGpW8UQaghJoWeQ6C5E_rrKUNiwrxVQbU-l2TIzBpl5cgedJLhX4H-hUtzw"
    static let kBaseUrl = "https://api.matchmore.io/v5"

    // swiftlint:disable:next line_length
    static let kStagingApiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhbHBzIiwic3ViIjoiOGNhZWYwNWYtY2NkYi00YzA2LTg5MjEtMzc3ODkxNTQ3OWM0IiwiYXVkIjpbIlB1YmxpYyJdLCJuYmYiOjE1Mjk5MjQ3NjMsImlhdCI6MTUyOTkyNDc2MywianRpIjoiMSJ9.ag4w6Qx3RKm--opKzWdVeZ64mbUKaYTtbVcGQnxZ5M3OpD3g3DOapHVVULTXVlfOtm7tHrcfHNR1K0KbCEVnOw"
    static let kStagingBaseUrl = "http://35.201.116.232/v5"

    static let kWaitTimeInterval = 60.0

    static let shouldTestStaging = false
    static func configure() {
        let apiKey = shouldTestStaging ? kStagingApiKey : kApiKey
        let baseUrl = shouldTestStaging ? kStagingBaseUrl : kBaseUrl

        let config = MatchmoreConfig(apiKey: apiKey, serverUrl: baseUrl)
        Matchmore.configure(config)
    }
}

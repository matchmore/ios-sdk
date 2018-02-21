//
//  TestsConfig.swift
//  AlpsSDKTests
//
//  Created by Maciej Burda on 07/11/2017.
//  Copyright © 2018 Matchmore SA. All rights reserved.
//

@testable import AlpsSDK
@testable import Alps

class TestsConfig {
    // swiftlint:disable:next line_length
    static let kApiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhbHBzIiwic3ViIjoiYWYwOGExMDktNGY4Ni00NTEyLThhMTQtNzcwZjIzZDllY2YxIiwiYXVkIjpbIlB1YmxpYyJdLCJuYmYiOjE1MTg2MjIyODgsImlhdCI6MTUxODYyMjI4OCwianRpIjoiMSJ9.IgS_9CJguACM7YtREYHgcYmb58yeGpW8UQaghJoWeQ6C5E_rrKUNiwrxVQbU-l2TIzBpl5cgedJLhX4H-hUtzw"
    static let kBaseUrl = "https://api.matchmore.io/v5"
    
    // swiftlint:disable:next line_length
    static let kStagingApiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhbHBzIiwic3ViIjoiM2I1NTcxODEtMmVjMC00MWRhLTk5NTItMzFkNTVkZDBlYzNjIiwiYXVkIjpbIlB1YmxpYyJdLCJuYmYiOjE1MTg2MjE1MjcsImlhdCI6MTUxODYyMTUyNywianRpIjoiMSJ9.xgPMU0mm0_7jKWdC7di-rCOU6PA7pld4pU0o5TrGwFPEO04DYttHy5MF_zw9Zw1AANbDgKMYbRQT4Lj9v011Cg"
    static let kStagingBaseUrl = "http://35.201.116.232/v5"
    
    static let kWaitTimeInterval = 10.0
    
    static let shouldTestStaging = true
    static func configure() {
        let apiKey = shouldTestStaging ? kStagingApiKey : kApiKey
        let baseUrl = shouldTestStaging ? kStagingBaseUrl : kBaseUrl
        let config = MatchMoreConfig(apiKey: apiKey, serverUrl: baseUrl, debugLog: false)
        MatchMore.configure(config)
    }
}

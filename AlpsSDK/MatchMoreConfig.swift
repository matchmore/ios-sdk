//
//  MatchMoreConfig.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 21/02/2018.
//  Copyright © 2018 Alps. All rights reserved.
//

import Foundation

/// `MatchMoreConfig` is a structure that defines all variables needed to configure MatchMore SDK.
public struct MatchMoreConfig {
    let apiKey: String
    let serverUrl: String
    let debugLog: Bool
    
    public init(apiKey: String, serverUrl: String = "https://api.matchmore.io/v5", debugLog: Bool = false) {
        self.apiKey = apiKey
        self.serverUrl = serverUrl
        self.debugLog = debugLog
    }
}

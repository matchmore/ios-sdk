//
//  MatchmoreConfig.swift
//  Matchmore
//
//  Created by Maciej Burda on 21/02/2018.
//  Copyright © 2018 Matchmore. All rights reserved.
//

import CoreLocation
import Foundation

/// `MatchmoreConfig` is a structure that defines all variables needed to configure Matchmore SDK.
public struct MatchmoreConfig {
    let apiKey: String
    let serverUrl: String
    let customLocationManager: CLLocationManager?

    public init(apiKey: String,
                serverUrl: String = "https://api.matchmore.io/v5",
                customLocationManager: CLLocationManager? = nil) {
        self.apiKey = apiKey
        self.serverUrl = serverUrl
        self.customLocationManager = customLocationManager
    }
}

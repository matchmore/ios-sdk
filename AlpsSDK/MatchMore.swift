//
//  MatchMore.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 14/11/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import Alps

public final class MatchMore {
    public static var apiKey = "" // JWT
    public static var worldId = "" // for sockets
    private static var prefix = "https://" // for sockets
    static var baseUrl = "api.matchmore.io" // TODO: add multiple targets
    static var apiVersion = "/v5"
    
    private(set) static var manager: AlpsManager = {
        return AlpsManager(apiKey: MatchMore.apiKey, baseURL: MatchMore.prefix + MatchMore.baseUrl + MatchMore.apiVersion)
    }()
    
    public static var matchDelegates = manager.delegates
    public static var publications = manager.publications
    public static var subscriptions = manager.subscriptions
    public static var deviceToken = manager.remoteNotificationManager.deviceToken
    public static var lastLocation = manager.locationUpdateManager.lastLocation
    public static var matches = Array(manager.matchMonitor.deliveredMatches)
}

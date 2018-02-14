//
//  MatchMore.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 14/11/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import Alps

/// `MatchMoreConfig` is a structure that defines all variables needed to configure MatchMore SDK.
public struct MatchMoreConfig {
    let apiKey: String
    let serverUrl: String
    let debugLog: Bool
    
    init(apiKey: String, serverUrl: String = "http://api.matchmore.io/v5", debugLog: Bool = false) {
        self.apiKey = apiKey
        self.serverUrl = serverUrl
        self.debugLog = debugLog
    }
}

/// `MatchMore` is a static facade for all public methods and properties available in the SDK.
public final class MatchMore {
    static var config: MatchMoreConfig?
    
    static var instance: AlpsManager = {
        assert(config == nil, "Please configure first.")
        return AlpsManager(apiKey: config!.apiKey, baseURL: config!.serverUrl)
    }()
    
    /// Configuration method
    public class func  configure(_ config: MatchMoreConfig) {
        MatchMore.config = config
    }
    
    /// Main mobile device created by `startUsingMainDevice()`
    public static var mainDevice: MobileDevice? {
        return instance.mobileDevices.main
    }
    
    /// Async store of all created publications.
    public static var publications: PublicationStore {
        return instance.publications
    }
    
    /// Async store of all created subscriptions.
    public static var subscriptions: SubscriptionStore {
        return instance.subscriptions
    }
    
    /// Async store of all known iBeacon Triples.
    public static var knownBeacons: BeaconTripleStore {
        return instance.contextManager.beaconTriples
    }
    
    /// APNS device token. To save token SDK uses KeyChain technology.
    public static var deviceToken: String? {
        return instance.remoteNotificationManager.deviceToken
    }
    
    /// Last location that was successfuly uploaded to MatchMore cloud.
    public static var lastLocation: Location? {
        return instance.locationUpdateManager.lastLocation
    }
}

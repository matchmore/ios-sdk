//
//  MatchMore.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 14/11/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import Alps

/// `MatchMore` is a static facade for all public methods and properties available in the SDK.
public final class MatchMore {
    
    // MARK: - Private
    internal static var prefix = "https://"
    internal static var baseUrl = "api.matchmore.io"
    internal static var apiVersion = "/v5"
    
    // MARK: - Public
    
    /// Static instance of `AlpsManager` the main SDK object. Right now you can only use one instance of alps manager through this static accessor.
    public private(set) static var manager: AlpsManager = {
        return AlpsManager(apiKey: MatchMore.apiKey, baseURL: MatchMore.prefix + MatchMore.baseUrl + MatchMore.apiVersion)
    }()
    
    /// JSON Web Token used to sign requests sent to MatchMore cloud.
    public static var apiKey = ""
    
    /// Unique identifier of created world. Right now it's used only for socket communication.
    public static var worldId = ""
    
    /// Async store of all created publications.
    public static var publications = manager.publications
    
    /// Async store of all created subscriptions.
    public static var subscriptions = manager.subscriptions
    
    /// Async store of all known iBeacon Triples.
    public static var knownBeacons = manager.contextManager.beaconTriples
    
    /// APNS device token. To save token SDK uses KeyChain technology.
    public static var deviceToken = manager.remoteNotificationManager.deviceToken
    
    /// Last location that was successfuly uploaded to MatchMore cloud.
    public static var lastLocation = manager.locationUpdateManager.lastLocation
}

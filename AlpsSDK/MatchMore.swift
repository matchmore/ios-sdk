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
    public static var apiKey = ""
    public static var worldId = ""
    private static var prefix = "http://"
    internal static var baseUrl = "api.matchmore.io"
    internal static var apiVersion = "/v5"
    
    private(set) static var manager: AlpsManager = {
        return AlpsManager(apiKey: MatchMore.apiKey, baseURL: MatchMore.prefix + MatchMore.baseUrl + MatchMore.apiVersion)
    }()
    
    public static var matchDelegates = MatchMore.manager.delegates
    public static var publications = MatchMore.manager.publications
    public static var subscriptions = MatchMore.manager.subscriptions
}

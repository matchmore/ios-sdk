//
//  MatchMore.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 14/11/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation

public final class MatchMore {
    public static var apiKey = ""
    internal static var baseUrl = "http://146.148.15.57/v5"
    
    public private(set) static var manager: AlpsManager = {
        return AlpsManager(apiKey: MatchMore.apiKey, baseURL: MatchMore.baseUrl)
    }()
}
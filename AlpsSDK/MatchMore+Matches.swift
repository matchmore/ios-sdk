//
//  MatchMore+Matches.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 15/11/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation

public extension MatchMore {
    public class func startPollingMatches() {
        MatchMore.manager.matchMonitor.startPollingMatches()
    }
    
    public class func startListeningForNewMatches() {
        MatchMore.manager.matchMonitor.openSocketForMatches()
    }
}

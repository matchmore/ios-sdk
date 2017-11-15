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
    
    public class func processPushNotification(pushNotification: [AnyHashable: Any]) {
        MatchMore.manager.remoteNotificationManager.consume(pushNotification: pushNotification)
    }
    
    public class func registerDeviceToken(deviceToken: String) {
        MatchMore.manager.remoteNotificationManager.registerDeviceToken(deviceToken: deviceToken)
    }
}

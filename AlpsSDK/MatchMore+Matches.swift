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
        manager.matchMonitor.startPollingMatches()
    }
    
    public class func startListeningForNewMatches() {
        manager.matchMonitor.openSocketForMatches()
    }
    
    public class func processPushNotification(pushNotification: [AnyHashable: Any]) {
        manager.remoteNotificationManager.consume(pushNotification: pushNotification)
    }
    
    public class func registerDeviceToken(deviceToken: String) {
        manager.remoteNotificationManager.registerDeviceToken(deviceToken: deviceToken)
    }
}

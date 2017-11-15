//
//  RemoteNotificationManager.swift
//  AlpsSDK
//
//  Created by Wen on 07.11.17.
//  Copyright © 2017 Alps. All rights reserved.
//

import UserNotifications
import UIKit

protocol RemoteNotificationManagerDelegate: class {
    func didReceiveMatchUpdateForDeviceId(deviceId: String)
}

public class RemoteNotificationManager: NSObject {
    
    private weak var delegate: RemoteNotificationManagerDelegate?
    public var deviceToken: String!
    
    init(delegate: RemoteNotificationManagerDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    public func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { (_, _) in
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    public func registerDeviceToken(deviceToken: String) {
        NSLog("DEVICE TOKEN: \(deviceToken)")
        self.deviceToken = deviceToken
    }
    
    public func consume(pushNotification: [AnyHashable: Any]) -> Bool {
        if pushNotification["matchId"] != nil {
            delegate?.didReceiveMatchUpdateForDeviceId(deviceId: "")
            return true
        }
        return false
    }
}

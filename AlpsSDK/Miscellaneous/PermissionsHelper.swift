//
//  PermissionsHelper.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 15/11/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import UserNotifications
import UIKit

public final class PermissionsHelper {
    public class func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { (_, _) in
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}

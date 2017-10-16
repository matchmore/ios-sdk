//
//  NotificationManager.swift
//  AlpsSDK
//
//  Created by Wen on 13.10.17.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class NotificationManager : NSObject, UNUserNotificationCenterDelegate {
    var alpsManager : AlpsManager
    var deviceToken : Data? = nil
    var deviceTokenString : String = ""
    var seenError : Bool = false
    var initialize : Bool = false
    
    init(alpsManager: AlpsManager){
        self.alpsManager = alpsManager
        super.init()
        self.seenError = registerForPushNotifications()
    }
    
    func registerForPushNotifications() -> Bool{
        // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in
                print("***********************************************")
                print("Permission granted: \(granted)")
                
                guard granted else {self.seenError = true
                    return }
                // If get notification settings is not .authorized, register for remote notification is not called
                self.getNotificationSettings()
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            self.getNotificationSettings()
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 8 support
        else if #available(iOS 8, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            self.getNotificationSettings()
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 7 support
        else {  
            UIApplication.shared.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
            self.getNotificationSettings()
        }
        
        return !UIApplication.shared.isRegisteredForRemoteNotifications
    }
    
    
    func getNotificationSettings(){
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                print("***********************************************")
                print("Notification settings: \(settings)")
                guard settings.authorizationStatus == .authorized else { return }
            }
        } else {
            // Fallback on earlier versions
            print("************PREVIOUS VERSION")
        }
    }
    
    // Called when AppDelegate func didRegisterForRemoteNotificationsWithDeviceToken
    //
    func registerDeviceToken(deviceToken: Data, deviceTokenString : String){
        print("REGISTERED DEVICE TOKEN")
        self.deviceToken = deviceToken
        self.deviceTokenString = deviceTokenString
        self.initialize = true
    }
    
    func handleRemoteNotification(userInfo: [AnyHashable : Any], fetchCompletionHandler: UIBackgroundFetchResult){
        
    }
    
    // MARK: UNUserNotificationCenter Delegate
    // Handle notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // CODE
        print(response.description)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // CODE
        print(notification.hashValue)
    }
}

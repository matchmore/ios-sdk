//
//  RemoteNotificationManager.swift
//  AlpsSDK
//
//  Created by Wen on 07.11.17.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

protocol RemoteNotificationManagerDelegate: class {
    func remoteNotificationManager(manager: RemoteNotificationManager, registerDeviceToken: Data)
    func remoteNotificationManager(manager: RemoteNotificationManager, handleRemoteNotification: [AnyHashable: Any])
}

class RemoteNotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    private weak var delegate: RemoteNotificationManagerDelegate?
    var deviceToken: Data?
    var deviceTokenString = ""
    
    init(delegate: RemoteNotificationManagerDelegate) {
        super.init()
        self.delegate = delegate
        initialize()
    }
    
    func initialize() {
        registerForPushNotifications()
    }
    
    private func registerForPushNotifications() {
        // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { (granted, _) in
                print("***********************************************")
                print("Permission granted: \(granted)")
                
                // If get notification settings is not .authorized, register for remote notification is not called
                self.getNotificationSettings()
                UNUserNotificationCenter.current().delegate = self
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
        print("Notification Manager is initialized.")
    }
    
    private func getNotificationSettings() {
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
    func registerDeviceToken(deviceToken: Data) {
        print("REGISTERED DEVICE TOKEN")
        self.deviceToken = deviceToken
    }
    
    func handleRemoteNotification(userInfo: [AnyHashable: Any]) {
        print("--------- handle remote notification")
        print(userInfo.description)
    }
    
    // MARK: UNUserNotificationCenter Delegate
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Called when app is open in background and click on notification
        print("did Receive function : ")
        print(response.notification.request.content.body)
        completionHandler()
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Called when app is in foreground
        // Assume that the request.content.body contains the match id.
        print("will present function : ")
        print(notification.request.content.body)
    }
}

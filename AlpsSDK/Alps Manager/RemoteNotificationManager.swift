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
    func remoteNotificationManager(manager: RemoteNotificationManager, didReceiveNotification: String)
}

public class RemoteNotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    private weak var delegate: RemoteNotificationManagerDelegate?
    public var deviceToken: String!
    
    init(delegate: RemoteNotificationManagerDelegate) {
        super.init()
        self.delegate = delegate
        registerForPushNotifications()
    }
    
    private func registerForPushNotifications() {
        // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { (granted, _) in
                NSLog("***********************************************")
                NSLog("Permission granted: \(granted)")

                // If get notification settings is not .authorized, register for remote notification is not called
                self.getNotificationSettings()
                UNUserNotificationCenter.current().delegate = self
                DispatchQueue.main.async {
                     UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        
        NSLog("Notification Manager is initialized.")
    }
    
    private func getNotificationSettings() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                NSLog("***********************************************")
                NSLog("Notification settings: \(settings)")
                guard settings.authorizationStatus == .authorized else { return }
            }
        } else {
            // Fallback on earlier versions
            NSLog("************PREVIOUS VERSION*************")
            NSLog("NOT SUPPORTED BY ALPS SDK for iOS less than 10.")
        }
    }
    
    // Called when AppDelegate func didRegisterForRemoteNotificationsWithDeviceToken
    //
    public func registerDeviceToken(deviceToken: String) {
        NSLog("REGISTERED DEVICE TOKEN")
        self.deviceToken = deviceToken
    }
    
    // MARK: UNUserNotificationCenter Delegate
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Called when app is open in background and click on notification
        NSLog("did Receive function : ")
        NSLog(response.notification.request.content.body)
        delegate?.remoteNotificationManager(manager: self, didReceiveNotification: response.notification.request.content.body)
        completionHandler()
    }
    
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Called when app is in foreground
        // Assume that the request.content.body contains the device id.
        NSLog("will present function : ")
        NSLog(notification.request.content.body)
        delegate?.remoteNotificationManager(manager: self, didReceiveNotification: notification.request.content.body)
    }
}

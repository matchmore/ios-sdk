//
//  AppDelegate.swift
//  AlpsExample
//
//  Created by Maciej Burda on 21/02/2018.
//  Copyright © 2018 Alps. All rights reserved.
//

import UIKit
import AlpsSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var exampleMatchHandler: ExampleMatchHandler!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // swiftlint:disable line_length
        let config = MatchMoreConfig(apiKey: "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhbHBzIiwic3ViIjoiYzM5MzFhNDgtYmQ4Mi00NDVmLWI2NTYtMTEyN2ZkY2FiYjBlIiwiYXVkIjpbIlB1YmxpYyJdLCJuYmYiOjE1MTExODMxOTgsImlhdCI6MTUxMTE4MzE5OCwianRpIjoiMSJ9.ZvZ-cWwlUJv_dPpn1pSUoHoRT-7yoH4HjFqofnaDxMk5ZSwh0v9yn2HmnxejixinApGr-P-PAXcbisFuREVgPA")
        MatchMore.configure(config)
        
        MatchMore.startUsingMainDevice { result in
            guard case .success(let mainDevice) = result else { print(result.errorMessage ?? ""); return }
            print("🏔 Using device: 🏔\n\(mainDevice.encodeToJSON())")
            
            // Start Monitoring Matches
            self.exampleMatchHandler = ExampleMatchHandler { matches, _ in
                print("🏔 You've got new matches!!! 🏔\n\(matches.map { $0.encodeToJSON() })")
            }
            MatchMore.matchDelegates += self.exampleMatchHandler
            
            // Create New Publication
            MatchMore.createPublicationForMainDevice(publication: Publication(topic: "Test Topic", range: 20, duration: 100, properties: ["test": "true"]), completion: { result in
                switch result {
                case .success(let publication):
                    print("🏔 Pub was created: 🏔\n\(publication.encodeToJSON())")
                case .failure(let error):
                    print("🌋 \(String(describing: error?.message)) 🌋")
                }
            })
            
            // Polling
            MatchMore.startPollingMatches()
            self.createPollingSubscription()
            
            // Socket (requires world_id)
            MatchMore.startListeningForNewMatches()
            self.createSocketSubscription()
            
            // APNS (Subscriptions is being created after receiving device token)
            UIApplication.shared.registerForRemoteNotifications()
            
            MatchMore.startUpdatingLocation()
        }
        return true
    }
    
    // Subscriptions
    
    func createSocketSubscription() {
        let subscription = Subscription(topic: "Test Topic", range: 20, duration: 100, selector: "test = true")
        subscription.pushers = ["ws"]
        MatchMore.createSubscriptionForMainDevice(subscription: subscription, completion: { result in
            switch result {
            case .success(let sub):
                print("🏔 Socket Sub was created 🏔\n\(sub.encodeToJSON())")
            case .failure(let error):
                print("🌋 \(String(describing: error?.message)) 🌋")
            }
        })
    }
    
    func createPollingSubscription() {
        let subscription = Subscription(topic: "Test Topic", range: 20, duration: 100, selector: "test = true")
        MatchMore.createSubscriptionForMainDevice(subscription: subscription, completion: { result in
            switch result {
            case .success(let sub):
                print("🏔 Polling Sub was created 🏔\n\(sub.encodeToJSON())")
            case .failure(let error):
                print("🌋 \(String(describing: error?.message)) 🌋")
            }
        })
    }
    
    func createApnsSubscription() {
        guard let deviceToken = MatchMore.deviceToken else { return }
        let subscription = Subscription(topic: "Test Topic", range: 20, duration: 100, selector: "test = true")
        subscription.pushers = ["apns://" + deviceToken]
        MatchMore.createSubscriptionForMainDevice(subscription: subscription, completion: { result in
            switch result {
            case .success(let sub):
                print("🏔 APNS Sub was created 🏔\n\(sub.encodeToJSON())")
            case .failure(let error):
                print("🌋 \(String(describing: error?.message)) 🌋")
            }
        })
    }
    
    // MARK: - APNS
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        MatchMore.registerDeviceToken(deviceToken: deviceTokenString)
        
        createApnsSubscription()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        MatchMore.processPushNotification(pushNotification: userInfo)
    }
}

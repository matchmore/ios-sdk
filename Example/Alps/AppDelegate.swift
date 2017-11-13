//
//  AppDelegate.swift
//  Alps
//
//  Created by rk on 09/27/2016.
//  Copyright (c) 2016 rk. All rights reserved.
//

import UIKit
import Alps
import AlpsSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var matchDelegate: MatchDelegate! = nil
    var alpsManager: AlpsManager! = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        alpsManager = AlpsManager(
            apiKey: "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhbHBzIiwic3ViIjoiNWQxYTM2NjgtZjZmYy00Y2MyLWJlYTgtYWNiMzM1M2MyY2U3IiwiYXVkIjpbIlB1YmxpYyJdLCJuYmYiOjE1MTAzMDMwNjIsImlhdCI6MTUxMDMwMzA2MiwianRpIjoiMiJ9.TmFQdEmkDT6RoI8inxb3zb9Hd8hHJ_0PeCsR1FbUp0jrRaFuBA5J1x7mCSkGYlKFmDmr1GjPhEshgG6qNgg1gQ",
            baseURL: "http://146.148.15.57/v5"
        )
        
        alpsManager.createMainDevice { result in
            guard case .success(let mainDevice) = result else { return }
            // Create New Publication
            let publication = Publication(topic: "Test Topic", range: 20, duration: 100, properties:  ["test": "true"])
            self.alpsManager.createPublication(publication: publication, completion: { result in
                print("Publication was created \(publication)")
            })
            
            // Create New Subscription
            let subscription = Subscription(topic: "Test Topic", range: 20, duration: 100, selector: "test = 'true'")
            self.alpsManager.createSubscription(subscription: subscription, completion: { _ in
                print("Subscription was created \(subscription)")
            })
            
            // Start Monitoring
            self.matchDelegate = MatchDelegate { matches, _ in print("You've got a match!\n\(matches)") }
            self.alpsManager.delegates += self.matchDelegate
            self.alpsManager.matchMonitor.startMonitoringFor(device: mainDevice!)
        }
        return true
    }
    
    register
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
    }
}

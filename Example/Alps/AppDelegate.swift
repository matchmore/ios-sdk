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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let alpsManager = AlpsManager(apiKey: "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhbHBzIiwic3ViIjoiNWQxYTM2NjgtZjZmYy00Y2MyLWJlYTgtYWNiMzM1M2MyY2U3IiwiYXVkIjpbIlB1YmxpYyJdLCJuYmYiOjE1MDk5ODQyMTQsImlhdCI6MTUwOTk4NDIxNCwianRpIjoiMSJ9.1JxzbbB91Jq2HvxYWjazrKeRXCEJxcc_XU2Tk1j0xNARwwGlS-JWAto8wHH_P6ASQ-7VzIvYv1wUoV8XAG-LVQ", baseURL: "http://146.148.15.57/v5")
        
        alpsManager.createMainDevice { _ in
            let publication = Publication(topic: "Test Topic", range: 20, duration: 100, properties:  ["test": "true"])
            alpsManager.createPublication(publication: publication, completion: { _ in
                let subscription = Subscription(topic: "Test Topic", range: 20, duration: 100, selector: "test = 'true'")
                alpsManager.createSubscription(subscription: subscription, completion: { _ in
                    print("We're all good! 🏔")
                })
            })
        }
        
        let matchDelegate = MatchDelegate { matches, _ in print("You've got a match!\n\(matches)") }
        if let mainDevice = alpsManager.mobileDevices.main {
            alpsManager.delegates += matchDelegate
            alpsManager.matchMonitor.startMonitoringFor(device: mainDevice)
        }
        
        return true
    }
}

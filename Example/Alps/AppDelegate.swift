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
        
        MatchMore.apiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhbHBzIiwic3ViIjoiMDBkNDcyYjYtNTFlNy00YTUwLWExYWMtMGJjMTYyNTM1OGRlIiwiYXVkIjpbIlB1YmxpYyJdLCJuYmYiOjE1MTA3Njc0MzgsImlhdCI6MTUxMDc2NzQzOCwianRpIjoiMTAifQ.nt5yC0ceGojh4jSbqfFMA4mciALC1NmrBUcLNlbvI8UL5KekOJFiO0bxUceTOEpqZGRglRz4rIFB40qFwP3aPA"
        MatchMore.worldId = "00d472b6-51e7-4a50-a1ac-0bc1625358de"
        
        MatchMore.createMainDevice { result in
            guard case .success(let mainDevice) = result else { print(result.errorMesseage ?? ""); return }
            print("Device was created \(mainDevice!.encodeToJSON())")
            
            // Start Monitoring Matches
            self.matchDelegate = MatchDelegate { matches, _ in
                print("You've got a match!\n\(matches.map { $0.encodeToJSON() })")
            }
            MatchMore.matchDelegates += self.matchDelegate
            
            // Create New Publication
            let publication = Publication(topic: "Test Topic", range: 20, duration: 100, properties: ["test":"true"])
            MatchMore.createPublication(publication: publication, completion: { result in
                if let error = result.errorMesseage {
                    print(error)
                } else {
                    print("Publication was created \(result.responseObject!!.encodeToJSON())")
                }
            })
            
            MatchMore.startPollingMatches()
            
            // Create New Subscription
            let subscription = Subscription(topic: "Test Topic", range: 20, duration: 100, selector: "test = true")
            subscription.pushers = ["ws"]
            MatchMore.createSubscription(subscription: subscription, completion: { result in
                if let error = result.errorMesseage {
                    print(error)
                } else {
                    print("Subscription was created \(result.responseObject!!.encodeToJSON())")
                }
            })
        }
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        MatchMore.manager.remoteNotificationManager.registerDeviceToken(deviceToken: deviceTokenString)
        

    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        _ = MatchMore.manager.remoteNotificationManager.consume(pushNotification: userInfo)
    }
}

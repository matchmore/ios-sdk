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
        
        MatchMore.apiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhbHBzIiwic3ViIjoiYThiMWIxZTItYjk1Ni00Nzc4LWEzNDgtYTFlM2QzNzA4YjEzIiwiYXVkIjpbIlB1YmxpYyJdLCJuYmYiOjE1MTA3NDk5NzUsImlhdCI6MTUxMDc0OTk3NSwianRpIjoiMSJ9.rrCVj3MGHgJleX1QP0UKDEQk2XK9jC_SbyfalOxxeknjR3CSqpsobjby4cqxye7J9w1Sz1rk0QdYl5R4V888fg"
        
        MatchMore.manager.createMainDevice { result in
            guard case .success(let mainDevice) = result else { return }
            if let error = result.errorMesseage {
                print(error)
            } else {
                print("Device was created \(mainDevice!.encodeToJSON())")
            }
            
            // Create New Publication
            let publication = Publication(topic: "Test Topic", range: 20, duration: 100, properties: ["test":"true"])
            MatchMore.manager.createPublication(publication: publication, completion: { result in
                if let error = result.errorMesseage {
                    print(error)
                } else {
                    print("Publication was created \(result.responseObject!!.encodeToJSON())")
                }
            })
            
            // Create New Subscription
            let subscription = Subscription(topic: "Test Topic", range: 20, duration: 100, selector: "test = true")
            MatchMore.manager.createSubscription(subscription: subscription, completion: { _ in
                if let error = result.errorMesseage {
                    print(error)
                } else {
                    print("Subscription was created \(result.responseObject!!.encodeToJSON())")
                }
            })
            
            // Start Monitoring
            self.matchDelegate = MatchDelegate { matches, _ in
                print("You've got a match!\n\(matches.map { $0.encodeToJSON() })")
            }
            MatchMore.manager.delegates += self.matchDelegate
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        MatchMore.manager.remoteNotificationManager.registerDeviceToken(deviceToken: deviceTokenString)
    }
}

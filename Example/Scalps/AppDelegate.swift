//
//  AppDelegate.swift
//  Scalps
//
//  Created by rk on 09/27/2016.
//  Copyright (c) 2016 rk. All rights reserved.
//

import UIKit
import Scalps
import ScalpsSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let apiKey = "f92183ca-c610-11e6-b704-e77af2b49f4f"
        let scalps = ScalpsManager(apiKey: apiKey)
        let userName = "Swift Exmple User 1"
        
        scalps.createUser(userName) {
            (_ user) in
            let deviceTemplate = Device(name: "Scalps Test Device 1",
                                        platform: "iOS 9.3",
                                        deviceToken: "870470ea-7a8e-11e6-b49b-5358f3beb662")
            scalps.createUser(userName) {
                (_ user) in
                if let u = user {
                    print("Created user: id = \(u.userId), name = \(u.name)")
                    scalps.createDevice(deviceTemplate, for: u) {
                        (_ device) in
                        if let d = device {
                            print("Created devide: id = \(d.deviceId), name = \(d.name)")
                        }
                    }
                }
            }
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}


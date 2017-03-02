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
    // Scalps API key
    // let apiKey = "ea0df90a-db0a-11e5-bd35-3bd106df139b"
    let scalps = ScalpsManager(apiKey: "ea0df90a-db0a-11e5-bd35-3bd106df139b")
    let userName = "Scalps Example User"
    var device: Device?
    var window: UIWindow?

    func createDevice() {
        scalps.createUser(userName) {
            (_ user) in
            if let u = user {
                print("Created user: id = \(u.userId), name = \(u.name)")

                self.scalps.createDevice(name: "Scalps Test Device 1", platform: "iOS 10.2",
                                    deviceToken: "870470ea-7a8e-11e6-b49b-5358f3beb662",
                                    latitude: 37.7858, longitude: -122.4064, altitude: 100,
                                    horizontalAccuracy: 5.0, verticalAccuracy: 5.0) {
                    (_ device) in
                    if let d = device {
                        print("Created device: id = \(d.deviceId), name = \(d.name)")
                        self.device = d
                    }
                }
            }
        }
    }

    // FIXME: use the user and device already created!
    func createPublication() {
        scalps.createUser(userName) {
            (_ user) in
            if let u = user {
                print("Created user: id = \(u.userId), name = \(u.name)")

                self.scalps.createDevice(name: "Scalps Test Device 3", platform: "iOS 10.2",
                                    deviceToken: "870470ea-7a8e-11e6-b49b-5358f3beb663",
                                    latitude: 37.7858, longitude: -122.4064, altitude: 100,
                                    horizontalAccuracy: 5.0, verticalAccuracy: 5.0) {
                    (_ device) in
                    if let d = device {
                        print("Created device: id = \(d.deviceId), name = \(d.name)")
                        let propertiesString = "{\"mood\": \"happy\"}"

                        self.scalps.createPublication(topic: "scalps-ios-test",
                                                 range: 100.0, duration: 0,
                                                 properties: propertiesString) {
                            (_ publication) in
                            if let p = publication {
                                print("Created publication: id = \(p.publicationId), topic = \(p.topic)")
                            }
                        }

                    }
                }
            }
        }
    }

    func createSubscription() {}

    func continouslyUpdatingLocation() {
        scalps.createUser(userName) {
            (_ user) in
            if let u = user {
                print("Created user: id = \(u.userId), name = \(u.name)")

                self.scalps.createDevice(name: "Scalps Test Device 5", platform: "iOS 10.2",
                                    deviceToken: "870470ea-7a8e-11e6-b49b-5358f3beb665",
                                    latitude: 37.7858, longitude: -122.4064, altitude: 100,
                                    horizontalAccuracy: 5.0, verticalAccuracy: 5.0) {
                    (_ device) in
                    if let d = device {
                        print("Created device: id = \(d.deviceId), name = \(d.name)")
                        self.scalps.startUpdatingLocation()
                    }
                }
            }
        }

        scalps.stopUpdatingLocation()
    }

    func monitorMatches() {
        scalps.startMonitoringMatches()
    }

    func monitorMatchesWithCompletion(completion: @escaping (_ match: Match?) -> Void) {
        scalps.onMatch(completion: completion)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Override point for customization after application launch.

        // Make some Scalps calls
        createDevice()
        createPublication()
        createSubscription()
        continouslyUpdatingLocation()
        // monitorMatches()
        monitorMatchesWithCompletion { (_ match) in NSLog("match completion called with \(match)") }

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

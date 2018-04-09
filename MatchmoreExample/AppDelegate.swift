//
//  AppDelegate.swift
//  MatchmoreExample
//
//  Created by Maciej Burda on 21/02/2018.
//  Copyright © 2018 Matchmore. All rights reserved.
//

import Matchmore
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    var exampleMatchHandler: ExampleMatchHandler!

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // swiftlint:disable line_length
        let config = MatchMoreConfig(apiKey: "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhbHBzIiwic3ViIjoiYzM5MzFhNDgtYmQ4Mi00NDVmLWI2NTYtMTEyN2ZkY2FiYjBlIiwiYXVkIjpbIlB1YmxpYyJdLCJuYmYiOjE1MTExODMxOTgsImlhdCI6MTUxMTE4MzE5OCwianRpIjoiMSJ9.ZvZ-cWwlUJv_dPpn1pSUoHoRT-7yoH4HjFqofnaDxMk5ZSwh0v9yn2HmnxejixinApGr-P-PAXcbisFuREVgPA")
        Matchmore.configure(config)

        Matchmore.startUsingMainDevice { result in
            guard case let .success(mainDevice) = result else { print(result.errorMessage ?? ""); return }
            print("🏔 Using device: 🏔\n\(mainDevice.encodeToJSON())")

            // Start Monitoring Matches
            self.exampleMatchHandler = ExampleMatchHandler { matches, _ in
                print("🏔 You've got new matches!!! 🏔\n\(matches.map { $0.encodeToJSON() })")
            }
            Matchmore.matchDelegates += self.exampleMatchHandler

            // Create New Publication
            Matchmore.createPublicationForMainDevice(publication: Publication(topic: "Test Topic", range: 20, duration: 100, properties: ["test": "true"]), completion: { result in
                switch result {
                case let .success(publication):
                    print("🏔 Pub was created: 🏔\n\(publication.encodeToJSON())")
                case let .failure(error):
                    print("🌋 \(String(describing: error?.message)) 🌋")
                }
            })

            // Polling
            Matchmore.startPollingMatches(pollingTimeInterval: 5)
            self.createPollingSubscription()

            // Socket (requires world_id)
            Matchmore.startListeningForNewMatches()
            self.createSocketSubscription()

            // APNS (Subscriptions is being created after receiving device token)
            UIApplication.shared.registerForRemoteNotifications()

            Matchmore.startUpdatingLocation()
        }
        return true
    }

    // Subscriptions

    func createSocketSubscription() {
        let subscription = Subscription(topic: "Test Topic", range: 20, duration: 100, selector: "test = true")
        subscription.pushers = ["ws"]
        Matchmore.createSubscriptionForMainDevice(subscription: subscription, completion: { result in
            switch result {
            case let .success(sub):
                print("🏔 Socket Sub was created 🏔\n\(sub.encodeToJSON())")
            case let .failure(error):
                print("🌋 \(String(describing: error?.message)) 🌋")
            }
        })
    }

    func createPollingSubscription() {
        let subscription = Subscription(topic: "Test Topic", range: 20, duration: 100, selector: "test = true")
        Matchmore.createSubscriptionForMainDevice(subscription: subscription, completion: { result in
            switch result {
            case let .success(sub):
                print("🏔 Polling Sub was created 🏔\n\(sub.encodeToJSON())")
            case let .failure(error):
                print("🌋 \(String(describing: error?.message)) 🌋")
            }
        })
    }

    func createApnsSubscription(_ deviceToken: String) {
        let subscription = Subscription(topic: "Test Topic", range: 20, duration: 100, selector: "test = true")
        subscription.pushers = ["apns://" + deviceToken]
        Matchmore.createSubscriptionForMainDevice(subscription: subscription, completion: { result in
            switch result {
            case let .success(sub):
                print("🏔 APNS Sub was created 🏔\n\(sub.encodeToJSON())")
            case let .failure(error):
                print("🌋 \(String(describing: error?.message)) 🌋")
            }
        })
    }

    // MARK: - APNS

    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", { $0 + String(format: "%02X", $1) })
        Matchmore.registerDeviceToken(deviceToken: deviceTokenString)

        createApnsSubscription(deviceTokenString)
    }

    func application(_: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        Matchmore.processPushNotification(pushNotification: userInfo)
    }
}

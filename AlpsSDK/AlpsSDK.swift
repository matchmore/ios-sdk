//
//  Alps.swift
//  AlpsSDK
//
//  Created by Rafal Kowalski on 03/10/2016
//  Copyright © 2016 Alps. All rights reserved.
//

import Foundation
import Alps

protocol AlpsSDK {

    // create Alps entities
    func createUser(_ userName: String, completion: @escaping (_ user: User?) -> Void)

    // XXX: assume one user and one device in the AlpsManager for now
    func createMobileDevice(name: String, platform: String, deviceToken: String,
                      latitude: Double, longitude: Double, altitude: Double,
                      horizontalAccuracy: Double, verticalAccuracy: Double,
                      completion: @escaping (_ device: MobileDevice?) -> Void)
    func createPinDevice(name: String, latitude: Double, longitude: Double, altitude: Double,
                         horizontalAccuracy: Double, verticalAccuracy: Double,
                         completion: @escaping (_ device: PinDevice?) -> Void)
    func createIBeaconDevice(name: String, proximityUUID: String, major: NSNumber, minor: NSNumber,
                            completion: @escaping (_ device: IBeaconDevice?) -> Void)

    func createPublication(topic: String, range: Double, duration: Double, properties: [String:String],
                           completion: @escaping (_ publication: Publication?) -> Void)

    func createSubscription(topic: String, selector: String, range: Double, duration: Double,
                                   completion: @escaping (_ subscription: Subscription?) -> Void)

    // update device location
    func updateLocation(latitude: Double, longitude: Double, altitude: Double,
                        horizontalAccuracy: Double, verticalAccuracy: Double,
                        completion: @escaping (_ location: Location?) -> Void)

    // queries
    func getUser(_ userId: String, completion: @escaping (_ user: User) -> Void)
    func getUser(completion: @escaping (_ user: User) -> Void)
    func getDevice(_ deviceId: String, completion: @escaping (_ device: Device) -> Void)
    func getDevice(completion: @escaping (_ device: Device) -> Void)
    func getPublication(_ userId:String, deviceId:String, publicationId: String, completion: @escaping (_ publication: Publication) -> Void)
    func deletePublication(_ userId:String, deviceId:String, publicationId: String, completion: @escaping () -> Void)
    func getAllPublicationsForDevice(_ userId:String, deviceId: String, completion: @escaping (_ publications: [Publication]) -> Void)
    func getSubscription(_ userId:String, deviceId:String, subscriptionId: String, completion: @escaping (_ subscription: Subscription) -> Void)
    func deleteSubscription(_ userId:String, deviceId:String, subscriptionId: String, completion: @escaping () -> Void)
    func getAllSubscriptionsForDevice(_ userId:String, deviceId:String, completion: @escaping (_ subscriptions: [Subscription]) -> Void)

    // cancel (unpublish and unsubscribe)

    // delete Alps entities

    // query stats

    // Matches
    func getAllMatches(completion: @escaping (_ matches: Matches) -> Void)
    // register match handlers
    func onMatch(completion: @escaping (_ match: Match) -> Void)
    // Beacons
}

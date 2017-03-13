//
//  Scalps.swift
//  ScalpsSDK
//
//  Created by Rafal Kowalski on 03/10/2016
//  Copyright © 2016 Scalps. All rights reserved.
//

import Foundation
import Scalps

protocol ScalpsSDK {

    // create Scalps entities
    func createUser(_ userName: String, completion: @escaping (_ user: User?) -> Void)

    // XXX: assume one user and one device in the ScalpsManager for now
    func createDevice(name: String, platform: String, deviceToken: String,
                      latitude: Double, longitude: Double, altitude: Double,
                      horizontalAccuracy: Double, verticalAccuracy: Double,
                      completion: @escaping (_ device: Device?) -> Void)

    func createPublication(topic: String, range: Double, duration: Double, properties: Properties,
                           completion: @escaping (_ publication: Publication?) -> Void)

    func createSubscription(topic: String, selector: String, range: Double, duration: Double,
                                   completion: @escaping (_ subscription: Subscription?) -> Void)

    // update device location
    func updateLocation(latitude: Double, longitude: Double, altitude: Double,
                        horizontalAccuracy: Double, verticalAccuracy: Double,
                        completion: @escaping (_ location: DeviceLocation?) -> Void)

    // queries
    func getUser(_ userId: String, completion: @escaping (_ user: User) -> Void)
    func getUser(completion: @escaping (_ user: User) -> Void)
    func getDevice(_ deviceId: String, completion: @escaping (_ device: Device) -> Void)
    func getDevice(completion: @escaping (_ device: Device) -> Void)
    func getPublication(_ publicationId: String, completion: @escaping (_ publication: Publication) -> Void)
    func getAllPublicationsForDevice(_ deviceId: String, completion: @escaping (_ publications: [Publication]) -> Void)
    func getAllPublications(completion: @escaping (_ publication: [Publication]) -> Void)
    func getSubscription(_ subscriptionId: String, completion: @escaping (_ subscription: Subscription) -> Void)
    func getAllSubscriptionsForDevice(_ deviceId: String, completion: @escaping (_ subscriptions: [Subscription]) -> Void)
    func getAllSubscriptions(completion: @escaping (_ subscriptions: [Subscription]) -> Void)

    // cancel (unpublish and unsubscribe)

    // delete Scalps entities

    // query stats

    // Matches
    func getAllMatches(completion: @escaping (_ matches: Matches) -> Void)
    // register match handlers
    func onMatch(completion: @escaping (_ match: Match) -> Void)
}

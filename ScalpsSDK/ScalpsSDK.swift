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

    func createPublication(topic: String, range: Double, duration: Double, properties: String,
                           completion: @escaping (_ publication: Publication?) -> Void)

    func createSubscription(topic: String, selector: String, range: Double, duration: Double,
                                   completion: @escaping (_ subscription: Subscription?) -> Void)

    // update device location
    func updateLocation(latitude: Double, longitude: Double, altitude: Double,
                        horizontalAccuracy: Double, verticalAccuracy: Double,
                        completion: @escaping (_ location: DeviceLocation?) -> Void)

    // cancel (unpublish and unsubscribe)

    // delete Scalps entities

    // query stats

    // register match handlers

    // XXX: prototype
    // func onMatch(completion: @escaping (_ match: Match?)
}

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
    // func createDevice(_ device: Device, for user: User, completion: @escaping (_ device: Device?) -> Void)
    // XXX: assume one user and one device in the ScalpsManager
    // func createDevice(_ device: Device, completion: @escaping (_ device: Device?) -> Void) // throws
/*
    func createDevice(_ userId: String, name: String, platform: String,
                      deviceToken: String,
                      latitude: Double, longitude: Double, altitude: Double,
                      horizontalAccuracy: Double, verticalAccuracy: Double,
                      completion: @escaping (_ device: Device?) -> Void)
                      */
    func createDevice(name: String, platform: String, deviceToken: String,
                      latitude: Double, longitude: Double, altitude: Double,
                      horizontalAccuracy: Double, verticalAccuracy: Double,
                      completion: @escaping (_ device: Device?) -> Void)

    func createPublication(_ publication: Publication, for user: User, on device: Device,
                           completion: @escaping (_ publication: Publication?) -> Void)
    func createSubscription(_ subscription: Subscription, for user: User, on device: Device,
                            completion: @escaping (_ subscription: Subscription?) -> Void)

    // update device location
    func updateLocation(_ location:DeviceLocation, for user: User, on device: Device,
                        completion: @escaping (_ location: DeviceLocation?) -> Void)

    // cancel (unpublish and unsubscribe)

    // delete Scalps entities

    // query stats

    // register match handlers
}

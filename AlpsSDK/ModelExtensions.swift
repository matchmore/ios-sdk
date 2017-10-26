//
//  ModelExtensions.swift
//  Alps
//
//  Created by Rafal Kowalski on 04/10/2016
//  Copyright © 2016 Alps. All rights reserved.
//

import Foundation
import Alps

extension IBeaconDevice {
    //TOCHANGE: put it in internal when beaconManager is working.
    public convenience init(name: String, proximityUUID: String, major: NSNumber, minor: NSNumber) {
        self.init()
        self.name = name
        self.deviceType = DeviceType.ibeacondevice
        self.proximityUUID = proximityUUID
        self.major = major as? Int32
        self.minor = minor as? Int32
    }
}

extension MobileDevice {
    internal convenience init(name: String, platform: String, deviceToken: String, location: Location?) {
        self.init()
        self.name = name
        self.deviceType = DeviceType.mobileDevice
        self.platform = platform
        self.deviceToken = deviceToken
        self.location = location
    }
}

extension PinDevice {
    internal convenience init(name: String, location: Location) {
        self.init()
        self.name = name
        self.deviceType = DeviceType.pinDevice
        self.location = location
    }
}

extension Publication {

    internal convenience init(deviceId: String, topic: String, range: Double, duration: Double, properties: [String: String]) {
        self.init()
        // XXX: use the deviceId of the DeviceLocation provided
        self.deviceId = deviceId
        self.topic = topic
        self.range = range
        self.duration = duration
        self.properties = properties
    }
}

extension Subscription {

    internal convenience init(deviceId: String, topic: String, range: Double, duration: Double, selector: String) {
        self.init()
        self.deviceId = deviceId
        self.topic = topic
        self.range = range
        self.duration = duration
        self.selector = selector
    }
}

extension Location {

    internal convenience init(latitude: Double, longitude: Double, altitude: Double, horizontalAccuracy: Double, verticalAccuracy: Double) {
        self.init()
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.horizontalAccuracy = horizontalAccuracy
        self.verticalAccuracy = verticalAccuracy
    }
}

extension Match: CustomStringConvertible, Hashable {

    // XXX: take the hashValue based on the hashValue of matchId
    public var hashValue: Int {
        return id!.hashValue
    }

    // XXX: Define the match equality based on the matchId only
    public static func == (lhs: Match, rhs: Match) -> Bool {
        return lhs.id! == rhs.id!
    }

    public var description: String {
        return "Match: (\(id!), \(createdAt!))"
    }
}

extension ProximityEvent {

    public convenience init(deviceId: String, distance: Double) {
        self.init()
        self.deviceId = deviceId
        self.distance = distance
    }
}

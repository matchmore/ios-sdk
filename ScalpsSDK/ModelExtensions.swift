//
//  ModelExtensions.swift
//  Scalps
//
//  Created by Rafal Kowalski on 04/10/2016
//  Copyright © 2016 Scalps. All rights reserved.
//

import Foundation
import Scalps

extension Dictionary {
    mutating func merge(with dictionary: Dictionary) {
        dictionary.forEach { updateValue($1, forKey: $0) }
    }

    func merged(with dictionary: Dictionary) -> Dictionary {
        var dict = self
        dict.merge(with: dictionary)
        return dict
    }
}

extension User {
    public convenience init(name: String) {
        self.init()
        self.name = name
    }

    // XXX: The  problem is  we cannot  have a  stored property  in an
    // extension  so where  should we  store the  created device?   It
    // could help if we somehow always get the ScalpsManager reference
    // to store the values...
    /*
    public func createDevice(_ device: Device, completion: @escaping (_ device: Device?) -> Void) {
        let f = completion
        let _ = Scalps.UserAPI.createDevice(userId: self.userId!, device: device, completion: {
            (device, error) -> Void in

            if let d = device {
                self.devices.append(d)
            }

            f(device)
        })
    }
    */
}

extension Device {

    // Device(deviceId: UUID().uuidString, name: "Scalps Test Device 1",
    // platform: "iOS 9.3", deviceToken: "870470ea-7a8e-11e6-b49b-5358f3beb662")

    public convenience init(name: String, platform: String, deviceToken: String) {
        self.init()
        self.deviceId = UUID().uuidString
        self.name = name
        self.platform = platform
        self.deviceToken = deviceToken
    }
}

extension DeviceLocation {

    public convenience init(deviceId: String, altitude: Double, latitude: Double, longitude: Double) {
        self.init()
        self.deviceId = deviceId
        // XXX: use now for the timestamp
        let location = Location()
        location.altitude = altitude
        location.latitude = latitude
        location.longitude = longitude
        // XXX: use some defaults
        location.horizontalAccuracy = 5
        location.verticalAccuracy = 5
        self.location = location
    }
}

extension Publication {

    public convenience init(deviceId: String, topic: String, range: Double, duration: Double, location: DeviceLocation, properties: Properties) {
        self.init()
        // XXX: use now for the timestamp
        self.timestamp = now()
        self.publicationId = UUID().uuidString
        // XXX: use the deviceId of the DeviceLocation provided
        self.deviceId = deviceId
        self.topic = topic
        self.range = range
        self.duration = duration
        self.location = location.location
        self.properties = properties
        self.op = "create"
    }
}

extension Subscription {

    public convenience init(topic: String, range: Double, duration: Double, location: DeviceLocation, selector: String) {

        self.init()
        // XXX: use now for the timestamp
        self.timestamp = now()
        self.subscriptionId = UUID().uuidString
        self.deviceId = location.deviceId!
        self.topic = topic
        self.range = range
        self.duration = duration
        self.location = location.location
        self.selector = selector
        self.op = "create"
    }
}

/*
extension Payload: JSONEncodable {
    public var dictionary = [String:String]()

    public init() {}

    public init(dictionary: [String: String]) {
        self.dictionary = dictionary
    }

    // MARK: JSONEncodable
    internal func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        for (key, value) in self.dictionary {
            nillableDictionary[key] = value
        }

        return APIHelper.rejectNil(nillableDictionary) ?? [:]
    }
}
*/

// Generated using Sourcery 0.9.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Foundation

public extension Device {
    var encodableDevice: EncodableDevice {
        return EncodableDevice(object: self)
    }
}

open class EncodableDevice: NSObject, NSCoding {
    public let object: Device!
    public init(object: Device?) {
        self.object = object
    }

    public required init?(coder decoder: NSCoder) {
        object = Device()
        object?.id = decoder.decodeObject(forKey: "id") as? String
        object?.createdAt = decoder.decodeObject(forKey: "createdAt") as? Int64
        object?.updatedAt = decoder.decodeObject(forKey: "updatedAt") as? Int64
        object?.group = decoder.decodeObject(forKey: "group") as? [String]
        object?.name = decoder.decodeObject(forKey: "name") as? String
        object?.deviceType = DeviceType(rawValue: decoder.decodeObject(forKey: "deviceType") as! String)
    }

    public func encode(with encoder: NSCoder) {
        encoder.encode(object?.id, forKey: "id")
        encoder.encode(object?.createdAt, forKey: "createdAt")
        encoder.encode(object?.updatedAt, forKey: "updatedAt")
        encoder.encode(object?.group, forKey: "group")
        encoder.encode(object?.name, forKey: "name")
        encoder.encode(object?.deviceType?.rawValue, forKey: "deviceType")
    }
}

public extension IBeaconDevice {
    var encodableIBeaconDevice: EncodableIBeaconDevice {
        return EncodableIBeaconDevice(object: self)
    }
}

open class EncodableIBeaconDevice: NSObject, NSCoding {
    public let object: IBeaconDevice!
    public init(object: IBeaconDevice?) {
        self.object = object
    }

    public required init?(coder decoder: NSCoder) {
        object = IBeaconDevice()
        object?.proximityUUID = decoder.decodeObject(forKey: "proximityUUID") as? String
        object?.major = decoder.decodeObject(forKey: "major") as? Int32
        object?.minor = decoder.decodeObject(forKey: "minor") as? Int32
        object?.id = decoder.decodeObject(forKey: "id") as? String
        object?.createdAt = decoder.decodeObject(forKey: "createdAt") as? Int64
        object?.updatedAt = decoder.decodeObject(forKey: "updatedAt") as? Int64
        object?.group = decoder.decodeObject(forKey: "group") as? [String]
        object?.name = decoder.decodeObject(forKey: "name") as? String
        object?.deviceType = DeviceType(rawValue: decoder.decodeObject(forKey: "deviceType") as! String)
    }

    public func encode(with encoder: NSCoder) {
        encoder.encode(object?.proximityUUID, forKey: "proximityUUID")
        encoder.encode(object?.major, forKey: "major")
        encoder.encode(object?.minor, forKey: "minor")
        encoder.encode(object?.id, forKey: "id")
        encoder.encode(object?.createdAt, forKey: "createdAt")
        encoder.encode(object?.updatedAt, forKey: "updatedAt")
        encoder.encode(object?.group, forKey: "group")
        encoder.encode(object?.name, forKey: "name")
        encoder.encode(object?.deviceType?.rawValue, forKey: "deviceType")
    }
}

public extension IBeaconTriple {
    var encodableIBeaconTriple: EncodableIBeaconTriple {
        return EncodableIBeaconTriple(object: self)
    }
}

open class EncodableIBeaconTriple: NSObject, NSCoding {
    public let object: IBeaconTriple!
    public init(object: IBeaconTriple?) {
        self.object = object
    }

    public required init?(coder decoder: NSCoder) {
        object = IBeaconTriple()
        object?.deviceId = decoder.decodeObject(forKey: "deviceId") as? String
        object?.proximityUUID = decoder.decodeObject(forKey: "proximityUUID") as? String
        object?.major = decoder.decodeObject(forKey: "major") as? Int32
        object?.minor = decoder.decodeObject(forKey: "minor") as? Int32
    }

    public func encode(with encoder: NSCoder) {
        encoder.encode(object?.deviceId, forKey: "deviceId")
        encoder.encode(object?.proximityUUID, forKey: "proximityUUID")
        encoder.encode(object?.major, forKey: "major")
        encoder.encode(object?.minor, forKey: "minor")
    }
}

public extension Location {
    var encodableLocation: EncodableLocation {
        return EncodableLocation(object: self)
    }
}

open class EncodableLocation: NSObject, NSCoding {
    public let object: Location!
    public init(object: Location?) {
        self.object = object
    }

    public required init?(coder decoder: NSCoder) {
        object = Location()
        object?.createdAt = decoder.decodeObject(forKey: "createdAt") as? Int64
        object?.latitude = decoder.decodeObject(forKey: "latitude") as? Double
        object?.longitude = decoder.decodeObject(forKey: "longitude") as? Double
        object?.altitude = decoder.decodeObject(forKey: "altitude") as? Double
        object?.horizontalAccuracy = decoder.decodeObject(forKey: "horizontalAccuracy") as? Double
        object?.verticalAccuracy = decoder.decodeObject(forKey: "verticalAccuracy") as? Double
    }

    public func encode(with encoder: NSCoder) {
        encoder.encode(object?.createdAt, forKey: "createdAt")
        encoder.encode(object?.latitude, forKey: "latitude")
        encoder.encode(object?.longitude, forKey: "longitude")
        encoder.encode(object?.altitude, forKey: "altitude")
        encoder.encode(object?.horizontalAccuracy, forKey: "horizontalAccuracy")
        encoder.encode(object?.verticalAccuracy, forKey: "verticalAccuracy")
    }
}

public extension Match {
    var encodableMatch: EncodableMatch {
        return EncodableMatch(object: self)
    }
}

open class EncodableMatch: NSObject, NSCoding {
    public let object: Match!
    public init(object: Match?) {
        self.object = object
    }

    public required init?(coder decoder: NSCoder) {
        object = Match()
        object?.id = decoder.decodeObject(forKey: "id") as? String
        object?.createdAt = decoder.decodeObject(forKey: "createdAt") as? Int64
        let encodable_publication = decoder.decodeObject(forKey: "publication") as? EncodablePublication
        object?.publication = encodable_publication?.object
        let encodable_subscription = decoder.decodeObject(forKey: "subscription") as? EncodableSubscription
        object?.subscription = encodable_subscription?.object
    }

    public func encode(with encoder: NSCoder) {
        encoder.encode(object?.id, forKey: "id")
        encoder.encode(object?.createdAt, forKey: "createdAt")
        encoder.encode(EncodablePublication(object: object?.publication), forKey: "publication")
        encoder.encode(EncodableSubscription(object: object?.subscription), forKey: "subscription")
    }
}

public extension MobileDevice {
    var encodableMobileDevice: EncodableMobileDevice {
        return EncodableMobileDevice(object: self)
    }
}

open class EncodableMobileDevice: NSObject, NSCoding {
    public let object: MobileDevice!
    public init(object: MobileDevice?) {
        self.object = object
    }

    public required init?(coder decoder: NSCoder) {
        object = MobileDevice()
        object?.platform = decoder.decodeObject(forKey: "platform") as? String
        object?.deviceToken = decoder.decodeObject(forKey: "deviceToken") as? String
        let encodable_location = decoder.decodeObject(forKey: "location") as? EncodableLocation
        object?.location = encodable_location?.object
        object?.id = decoder.decodeObject(forKey: "id") as? String
        object?.createdAt = decoder.decodeObject(forKey: "createdAt") as? Int64
        object?.updatedAt = decoder.decodeObject(forKey: "updatedAt") as? Int64
        object?.group = decoder.decodeObject(forKey: "group") as? [String]
        object?.name = decoder.decodeObject(forKey: "name") as? String
        object?.deviceType = DeviceType(rawValue: decoder.decodeObject(forKey: "deviceType") as! String)
    }

    public func encode(with encoder: NSCoder) {
        encoder.encode(object?.platform, forKey: "platform")
        encoder.encode(object?.deviceToken, forKey: "deviceToken")
        encoder.encode(EncodableLocation(object: object?.location), forKey: "location")
        encoder.encode(object?.id, forKey: "id")
        encoder.encode(object?.createdAt, forKey: "createdAt")
        encoder.encode(object?.updatedAt, forKey: "updatedAt")
        encoder.encode(object?.group, forKey: "group")
        encoder.encode(object?.name, forKey: "name")
        encoder.encode(object?.deviceType?.rawValue, forKey: "deviceType")
    }
}

public extension PinDevice {
    var encodablePinDevice: EncodablePinDevice {
        return EncodablePinDevice(object: self)
    }
}

open class EncodablePinDevice: NSObject, NSCoding {
    public let object: PinDevice!
    public init(object: PinDevice?) {
        self.object = object
    }

    public required init?(coder decoder: NSCoder) {
        object = PinDevice()
        let encodable_location = decoder.decodeObject(forKey: "location") as? EncodableLocation
        object?.location = encodable_location?.object
        object?.id = decoder.decodeObject(forKey: "id") as? String
        object?.createdAt = decoder.decodeObject(forKey: "createdAt") as? Int64
        object?.updatedAt = decoder.decodeObject(forKey: "updatedAt") as? Int64
        object?.group = decoder.decodeObject(forKey: "group") as? [String]
        object?.name = decoder.decodeObject(forKey: "name") as? String
        object?.deviceType = DeviceType(rawValue: decoder.decodeObject(forKey: "deviceType") as! String)
    }

    public func encode(with encoder: NSCoder) {
        encoder.encode(EncodableLocation(object: object?.location), forKey: "location")
        encoder.encode(object?.id, forKey: "id")
        encoder.encode(object?.createdAt, forKey: "createdAt")
        encoder.encode(object?.updatedAt, forKey: "updatedAt")
        encoder.encode(object?.group, forKey: "group")
        encoder.encode(object?.name, forKey: "name")
        encoder.encode(object?.deviceType?.rawValue, forKey: "deviceType")
    }
}

public extension Publication {
    var encodablePublication: EncodablePublication {
        return EncodablePublication(object: self)
    }
}

open class EncodablePublication: NSObject, NSCoding {
    public let object: Publication!
    public init(object: Publication?) {
        self.object = object
    }

    public required init?(coder decoder: NSCoder) {
        object = Publication()
        object?.id = decoder.decodeObject(forKey: "id") as? String
        object?.createdAt = decoder.decodeObject(forKey: "createdAt") as? Int64
        object?.worldId = decoder.decodeObject(forKey: "worldId") as? String
        object?.deviceId = decoder.decodeObject(forKey: "deviceId") as? String
        object?.topic = decoder.decodeObject(forKey: "topic") as? String
        object?.range = decoder.decodeObject(forKey: "range") as? Double
        object?.duration = decoder.decodeObject(forKey: "duration") as? Double
        object?.properties = decoder.decodeObject(forKey: "properties") as? [String: Any]
    }

    public func encode(with encoder: NSCoder) {
        encoder.encode(object?.id, forKey: "id")
        encoder.encode(object?.createdAt, forKey: "createdAt")
        encoder.encode(object?.worldId, forKey: "worldId")
        encoder.encode(object?.deviceId, forKey: "deviceId")
        encoder.encode(object?.topic, forKey: "topic")
        encoder.encode(object?.range, forKey: "range")
        encoder.encode(object?.duration, forKey: "duration")
        encoder.encode(object?.properties, forKey: "properties")
    }
}

public extension Subscription {
    var encodableSubscription: EncodableSubscription {
        return EncodableSubscription(object: self)
    }
}

open class EncodableSubscription: NSObject, NSCoding {
    public let object: Subscription!
    public init(object: Subscription?) {
        self.object = object
    }

    public required init?(coder decoder: NSCoder) {
        object = Subscription()
        object?.id = decoder.decodeObject(forKey: "id") as? String
        object?.createdAt = decoder.decodeObject(forKey: "createdAt") as? Int64
        object?.worldId = decoder.decodeObject(forKey: "worldId") as? String
        object?.deviceId = decoder.decodeObject(forKey: "deviceId") as? String
        object?.topic = decoder.decodeObject(forKey: "topic") as? String
        object?.selector = decoder.decodeObject(forKey: "selector") as? String
        object?.range = decoder.decodeObject(forKey: "range") as? Double
        object?.duration = decoder.decodeObject(forKey: "duration") as? Double
        object?.matchTTL = decoder.decodeObject(forKey: "matchTTL") as? Double
        object?.matchDTL = decoder.decodeObject(forKey: "matchDTL") as? Double
        object?.pushers = decoder.decodeObject(forKey: "pushers") as? [String]
    }

    public func encode(with encoder: NSCoder) {
        encoder.encode(object?.id, forKey: "id")
        encoder.encode(object?.createdAt, forKey: "createdAt")
        encoder.encode(object?.worldId, forKey: "worldId")
        encoder.encode(object?.deviceId, forKey: "deviceId")
        encoder.encode(object?.topic, forKey: "topic")
        encoder.encode(object?.selector, forKey: "selector")
        encoder.encode(object?.range, forKey: "range")
        encoder.encode(object?.duration, forKey: "duration")
        encoder.encode(object?.matchTTL, forKey: "matchTTL")
        encoder.encode(object?.matchDTL, forKey: "matchDTL")
        encoder.encode(object?.pushers, forKey: "pushers")
    }
}

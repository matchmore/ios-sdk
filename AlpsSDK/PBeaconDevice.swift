//
//  PBeaconDevice.swift
//  AlpsSDK
//
//  Created by Wen on 04.08.17.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import Alps

open class PBeaconDevice : PDevice {
    public var deviceId: String?
    public var name: String?
    
    public var uuid: UUID
    public var major: NSNumber
    public var minor: NSNumber
    
//    convenience init(name: String, uuid: UUID, major: NSNumber, minor: NSNumber) {
//        self.init(name: name, uuid: uuid, major: major, minor: minor)
//    }
    
    public init(name:String, uuid: UUID, major: NSNumber, minor: NSNumber) {
        self.name = name
        self.uuid = uuid
        self.major = major
        self.minor = minor
    }
}

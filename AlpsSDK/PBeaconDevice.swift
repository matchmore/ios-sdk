//
//  PBeaconDevice.swift
//  AlpsSDK
//
//  Created by Wen on 04.08.17.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import Alps

class PBeaconDevice : PDevice {
    var deviceId: String?
    var name: String?
    
    var uuid: UUID
    var major: NSNumber
    var minor: NSNumber
    
//    convenience init(name: String, uuid: UUID, major: NSNumber, minor: NSNumber) {
//        self.init(name: name, uuid: uuid, major: major, minor: minor)
//    }
    
    init(name:String, uuid: UUID, major: NSNumber, minor: NSNumber) {
        self.name = name
        self.uuid = uuid
        self.major = major
        self.minor = minor
    }
}

//
//  PPinDevice.swift
//  AlpsSDK
//
//  Created by Wen on 04.08.17.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import Alps

open class PPinDevice : PDevice {
    public var deviceId: String?
    public var name: String?
    
    public var location : Location!
    
    public convenience init(name: String, location: Location) {
        self.init(name: name, location: location)
    }
}

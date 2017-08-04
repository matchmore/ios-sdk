//
//  PPinDevice.swift
//  AlpsSDK
//
//  Created by Wen on 04.08.17.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import Alps

class PPinDevice : PDevice {
    var deviceId: String?
    var name: String?
    
    var location : Location!
    
    convenience init(name: String, location: Location) {
        self.init(name: name, location: location)
    }
}

//
//  PMobileDevice.swift
//  AlpsSDK
//
//  Created by Wen on 04.08.17.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import Alps

open class PMobileDevice : PDevice {
    // Protocol
    public var deviceId: String?
    public var name: String?
    
    /**  The platform of the device, this can be any string representing the platform type, for instance &#39;iOS&#39;  */
    public var platform: String?
    /**  The deviceToken is the device push notification token given to this device by the OS, either iOS or Android for identifying the device with push notification services.  */
    public var deviceToken: String?
    public var location: Location?
    
    convenience init(name: String, platform: String, deviceToken: String) {
        self.init(name: name, platform: platform, deviceToken: deviceToken, location: Location())
    }
    
    public init(name: String, platform: String, deviceToken: String, location : Location?) {
        self.name = name
        self.platform = platform
        self.deviceToken = deviceToken
        self.location = location
    }
}

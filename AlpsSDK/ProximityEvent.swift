//
//  ProximityEvent.swift
//  AlpsSDK
//
//  Created by Wen on 29.08.17.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation

class ProximityEvent{
    var id : String?
    var createdAt : Int64?
    var deviceId : String?
    var distance : Double?
    
    init(deviceId: String, distance: Double){
        self.deviceId = deviceId
        self.distance = distance
    }
    
}

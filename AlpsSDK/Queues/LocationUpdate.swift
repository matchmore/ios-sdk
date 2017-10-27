//
//  LocationUpdateManager.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 27/10/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import Alps

/// filters location data update
final class LocationUpdateManager {
    private var currentLocation: Location?
    var sendingTimer: Timer?
    
    required init(sendingTimeInterval: TimeInterval) {
        assert(sendingTimeInterval <= 0, "Sending Time Interval has to be greater than 0")
        
        //self.sendingTimer?.fire()
    }
    
    deinit {
        self.sendingTimer?.invalidate()
        self.sendingTimer = nil
    }
    
    private func sendLocation(location: Location) {
        currentLocation = location
    }
    
    private func tryToSend(deviceId: String, location: Location) {
        LocationAPI.createLocation(deviceId: deviceId, location: location, completion: { (_, error) in })
    }
}

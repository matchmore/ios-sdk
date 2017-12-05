//
//  MatchMore+Location.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 15/11/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import Alps

public extension MatchMore {
    
    /// Starts location updating and sending to MatchMore's cloud.
    public class func startUpdatingLocation() {
        manager.contextManager.locationManager.startUpdatingLocation()
    }
    
    /// Stops location updating and sending to MatchMore's cloud.
    public class func stopUpdatingLocation() {
        manager.contextManager.locationManager.stopUpdatingLocation()
    }
    
    /// Allows manual registration of iBecaon devices.
    ///
    /// - Parameters:
    ///   - forUuid: uuid of a iBeacon device.
    ///   - identifier: identifier of a iBeacon device.
    public class func manualyStartRangingBeacon(forUuid: UUID, identifier: String) {
        manager.contextManager.startRanging(forUuid: forUuid, identifier: identifier)
    }
    
    /// Forces refreshing known iBecaon devices from MatchMore cloud.
    public class func refreshKnownBeacons(_ completion: (() -> Void)? = nil) {
        manager.contextManager.beaconTriples.updateBeaconTriplets(completion: completion)
    }
}

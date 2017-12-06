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
    
    /// Forces refreshing known iBecaon devices from MatchMore cloud.
    public class func refreshKnownBeacons() {
        manager.contextManager.beaconTriples.updateBeaconTriplets {
            manager.contextManager.startRanging()
        }
    }
}

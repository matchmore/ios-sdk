//
//  MatchMore+Location.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 15/11/2017.
//  Copyright © 2018 Matchmore SA. All rights reserved.
//

import Foundation

public extension MatchMore {
    
    /// Starts location updating and sending to MatchMore's cloud.
    public class func startUpdatingLocation() {
        instance.locationManager.startUpdatingLocation()
    }
    
    /// Stops location updating and sending to MatchMore's cloud.
    public class func stopUpdatingLocation() {
        instance.locationManager.stopUpdatingLocation()
    }
    
    /// Forces refreshing known iBecaon devices from MatchMore cloud.
    public class func refreshKnownBeacons() {
        instance.contextManager.beaconTriples.updateBeaconTriplets {
            instance.contextManager.startRanging()
        }
    }
}

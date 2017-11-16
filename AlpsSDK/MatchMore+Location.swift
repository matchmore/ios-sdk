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
    public class func startUpdatingLocation() {
        manager.contextManager.locationManager.startUpdatingLocation()
    }
    
    public class func stopUpdatingLocation() {
        manager.contextManager.locationManager.stopUpdatingLocation()
    }
    
    public class func startRanging(forUuid: UUID, identifier: String) {
        manager.contextManager.startRanging(forUuid: forUuid, identifier: identifier)
    }
    
    public class func refreshKnownBeacons(completion: @escaping (_ beacons: [IBeaconTriple]?) -> Void) {
        manager.contextManager.beaconTriples.updateBeaconTriplets {
            findKnownBeacons(completion: { (beacons) in
                completion(beacons)
            })
        }
    }
    
    public class func findKnownBeacons(completion: @escaping (_ beacons: [IBeaconTriple]?) -> Void) {
        manager.contextManager.beaconTriples.findAll(completion: { (result) in
            completion(result.responseObject)
        })
    }
}

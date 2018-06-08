//
//  Matchmore+Location.swift
//  Matchmore
//
//  Created by Maciej Burda on 15/11/2017.
//  Copyright © 2018 Matchmore SA. All rights reserved.
//

import Foundation

public extension Matchmore {
    /// Last location gathered by SDK.
    public static var lastLocation: Location? {
        return instance.locationUpdateManager.lastLocation
    }

    /// Starts location updating and sending to MatchMore's cloud.
    public class func startUpdatingLocation() {
        instance.contextManager.locationManager?.startUpdatingLocation()
    }

    /// Stops location updating and sending to MatchMore's cloud.
    public class func stopUpdatingLocation() {
        instance.contextManager.locationManager?.stopUpdatingLocation()
    }

    /// Starts ranging iBeacons that were set on Matchmore's cloud. Cloud is being notified about proxmity event every `updateTimeInterval` seconds.
    public class func startRangingBeacons(updateTimeInterval: TimeInterval) {
        instance.contextManager.proximityHandler.refreshTimer = Int(updateTimeInterval * 1000)
        instance.contextManager.beaconTriples.updateBeaconTriplets {
            instance.contextManager.startRanging()
        }
    }

    public class func triggerProxmityEventForDeviceId(deviceId: String, distance: Double, completion: ((Error?) -> Void)?) {
        let proximityEvent = ProximityEvent(deviceId: deviceId, distance: distance)
        DeviceAPI.triggerProximityEvents(deviceId: instance.mobileDevices.main!.id!, proximityEvent: proximityEvent) { (_, error) -> Void in
            completion?(error)
        }
    }
}

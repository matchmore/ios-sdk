//
//  ProximityHandler.swift
//  AlpsSDK
//
//  Created by Wen on 26.10.17.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import CoreLocation
import Alps

protocol ProximityHandlerDelegate: class {
    func didRangeBeacons(manager: ContextManager, beacons: [CLBeacon], knownBeacons: [IBeaconTriple])
}

final class ProximityHandler: ProximityHandlerDelegate {
    var refreshTimer: Int = 5 * 1000 // timer is in milliseconds
    lazy var beaconsDetected: [CLProximity: [IBeaconTriple]] = [:]
    lazy var beaconsTriggered: [CLProximity: [String: ProximityEvent]] = [:]
    
    init() {
        beaconsTriggered[CLProximity.unknown] = [String: ProximityEvent]()
        beaconsTriggered[CLProximity.immediate] = [String: ProximityEvent]()
        beaconsTriggered[CLProximity.far] = [String: ProximityEvent]()
        beaconsTriggered[CLProximity.near] = [String: ProximityEvent]()
    }
    
    func didRangeBeacons(manager: ContextManager, beacons: [CLBeacon], knownBeacons: [IBeaconTriple]) {
        let unknownBeacons = {
            return beacons.filter {$0.proximity == CLProximity.unknown}
        }
        let immediateBeacons = {
            return beacons.filter {$0.proximity == CLProximity.immediate}
        }
        let nearBeacons = {
            return beacons.filter {$0.proximity == CLProximity.near}
        }
        let farBeacons = {
            return beacons.filter {$0.proximity == CLProximity.far}
        }
        
        // Filter with existing beacons in application
        beaconsDetected[CLProximity.unknown] = synchronizeBeacons(beacons: unknownBeacons(), knownBeacons: knownBeacons)
        beaconsDetected[CLProximity.immediate] = synchronizeBeacons(beacons: immediateBeacons(), knownBeacons: knownBeacons)
        beaconsDetected[CLProximity.near] = synchronizeBeacons(beacons: nearBeacons(), knownBeacons: knownBeacons)
        beaconsDetected[CLProximity.far] = synchronizeBeacons(beacons: farBeacons(), knownBeacons: knownBeacons)
        
        // triggers for proximity event
        beaconsDetected.forEach { (arg) in
            let (key, value) = arg
            // Required conditions(proximity match) are successful
            actionContextMatch(key: key, value: value)
        }
    }
    
    // When the proximity match is successful, action the context match in the backend service
    private func actionContextMatch(key: CLProximity, value: [IBeaconTriple]) {
        let distance = setUp(key: key)
        value.forEach { (iBeaconTriple) in
            guard let deviceId = iBeaconTriple.deviceId else {return}
            guard let keys = beaconsTriggered[key]?.keys else {return}
            if keys.contains(deviceId) {
                // do refresh
                refreshTriggers(key: key, deviceId: deviceId, distance: distance)
            } else {
                // do trigger
                triggers(key: key, deviceId: deviceId, distance: distance)
            }
        }
    }
    
    // Trigger the proximity event
    private func triggers(key: CLProximity, deviceId: String, distance: Double) {
        let proximityEvent = ProximityEvent(deviceId: deviceId, distance: distance)
        sendProximityEvent(deviceId: MatchMore.manager.mobileDevices.items.first!.id!, proximityEvent: proximityEvent) {(_ proximityEvent) in
            guard let pe = proximityEvent else {return}
            self.beaconsTriggered[key]?[deviceId] = pe
        }
    }
    
    // Re-launch a proximity event depending on refreshTimer (Default : 60 seconds)
    private func refreshTriggers(key: CLProximity, deviceId: String, distance: Double) {
        // Check if the existed proximity event needs a refresh on a based timer
        guard let proximityEvent = beaconsTriggered[key]?[deviceId] else {return}
        // Represents  the UNIX current time in milliseconds
        let now = Date().nowTimeInterval()
        guard let proximityEventCreatedAt = proximityEvent.createdAt else {return}
        let gap = now - proximityEventCreatedAt
        let truncatedGap = Int(truncatingIfNeeded: gap)
        if truncatedGap > refreshTimer {
            // Send the refreshing proximity event based on the timer
            let newProximityEvent = ProximityEvent(deviceId: deviceId, distance: distance)
            sendProximityEvent(deviceId: MatchMore.manager.mobileDevices.items.first!.id!, proximityEvent: newProximityEvent) {(_ proximityEvent) in
                guard let pe = proximityEvent else {return}
                self.beaconsTriggered[key]?[deviceId] = pe
            }
        }
    }
    
    // MARK: - API CALLS
    // Send the proximity event to the cloud service
    private func sendProximityEvent(deviceId: String, proximityEvent: ProximityEvent, completion: @escaping (_ proximityEvent: ProximityEvent?) -> Void) {
        let userCompletion = completion
        DeviceAPI.triggerProximityEvents(deviceId: deviceId, proximityEvent: proximityEvent) {(proximityEvent, _) -> Void in
            userCompletion(proximityEvent)
        }
    }
    
    // MARK: - Helper Function
    // List of beacons currently tracked by the application, means beacons are registered in portal
    private func synchronizeBeacons(beacons: [CLBeacon], knownBeacons: [IBeaconTriple]) -> [IBeaconTriple] {
        var result = [IBeaconTriple]()
        beacons.forEach { (beacon) in
            let b = knownBeacons.filter {
                guard let proximityUUID = $0.proximityUUID else {return false}
                guard let major = $0.major else {return false}
                guard let minor = $0.minor else {return false}
                if (beacon.proximityUUID.uuidString.caseInsensitiveCompare(proximityUUID) == ComparisonResult.orderedSame)  && (beacon.major as? Int32) == major && (beacon.minor as? Int32) == minor {
                    return true
                }
                return false
            }
            if !b.isEmpty {
                result.append(b[0])
            }
        }
        return result
    }
    
    // setting up constant parameters depending on CLProximity distance
    private func setUp(key: CLProximity) -> Double {
        var distance = 0.0
        switch key {
        case .immediate:
            distance = 0.5
        case .near:
            distance = 3.0
        case .far:
            distance = 50.0
        case .unknown:
            distance = 200.0
        }
        return distance
    }
}

//
//  ContextManager.swift
//  Alps
//
//  Created by Rafal Kowalski on 28.09.16.
//  Copyright © 2016 Alps. All rights reserved.
//

import Foundation
import CoreLocation
import Alps

protocol ContextManagerDelegate: class {
    func contextManager(manager: ContextManager, didUpdateLocation: CLLocation)
    func contextManager(manager: ContextManager, didRangeClosestBeacon: CLBeacon)
    func contextManager(manager: ContextManager, didDetectBeacons: [CLBeacon])
}

class ContextManager: NSObject, CLLocationManagerDelegate {
    private weak var delegate: ContextManagerDelegate?

    let locationManager = CLLocationManager()

    // Beacons
    // Triggered proximity event map
    var refreshTimer: Int = 60 * 1000 // timer is in milliseconds
    var proximityTrigger = Set<CLProximity>()
    // [Is the id of the IBeaconDevice registered in the core : The returned ProximityEvent will be stored ]
    static var immediateTrigger: [String: ProximityEvent] = [:]
    static var nearTrigger: [String: ProximityEvent] = [:]
    static var farTrigger: [String: ProximityEvent] = [:]
    static var unknownTrigger: [String: ProximityEvent] = [:]
    var immediateBeacons: [String] = []
    var nearBeacons: [String] = []
    var farBeacons: [String] = []
    var unknownBeacons: [String] = []
    var immediateTimer: Timer?
    var nearTimer: Timer?
    var farTimer: Timer?
    var unknownTimer: Timer?

    init(delegate: ContextManagerDelegate) {
        super.init()
        self.delegate = delegate
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
    }

    // MARK: - Core Location Manager Delegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        delegate?.contextManager(manager: self, didUpdateLocation: lastLocation)
    }

    // MARK: - Beacons
    
    func startRanging(forUuid: UUID, identifier: String) {
        let beaconRegion = CLBeaconRegion(proximityUUID: forUuid, identifier: identifier)
        locationManager.startRangingBeacons(in: beaconRegion)
    }

    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        delegate?.contextManager(manager: self, didDetectBeacons: beacons)
        if let closestBeacon = beacons.max(by: { $0.accuracy < $1.accuracy }) {
            delegate?.contextManager(manager: self, didRangeClosestBeacon: closestBeacon)
        }
        parseBeaconsByProximity(beacons)
        proximityTrigger.forEach {
            triggerBeaconsProximityEvent(forCLProximity: $0)
        }
    }

    // TODO: improve code of method below so it matches swiftlint requirement regarding complexity + length
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    private func parseBeaconsByProximity(_ beacons: [CLBeacon]) {
        var ourBeacon: IBeaconDevice?
        beacons.forEach {
            let beacon = syncBeacon(beacon: $0)
        }
        for beacon in beacons {
            let b = syncBeacon(beacon: beacon)
            if b.isEmpty != true {
                ourBeacon = b[0]
            }
            if let deviceId = ourBeacon?.id {
                switch beacon.proximity {
                case .immediate:
                    if immediateBeacons.contains(deviceId) {
                        // If beacon is already detected no need to do anything
                    } else {
                        if nearBeacons.contains(deviceId) {
                            if let index = nearBeacons.index(of: deviceId) {
                                nearBeacons.remove(at: index)
                            }
                        }
                        if farBeacons.contains(deviceId) {
                            if let index = farBeacons.index(of: deviceId) {
                                farBeacons.remove(at: index)
                            }
                        }
                        if unknownBeacons.contains(deviceId) {
                            if let index = unknownBeacons.index(of: deviceId) {
                                unknownBeacons.remove(at: index)
                            }
                        }
                        immediateBeacons.append(deviceId)
                    }
                case .near:
                    if nearBeacons.contains(deviceId) {
                        // If beacon is already detected no need to do anything
                    } else {
                        if immediateBeacons.contains(deviceId) {
                            if let index = immediateBeacons.index(of: deviceId) {
                                immediateBeacons.remove(at: index)
                            }
                        }
                        if farBeacons.contains(deviceId) {
                            if let index = farBeacons.index(of: deviceId) {
                                farBeacons.remove(at: index)
                            }
                        }
                        if unknownBeacons.contains(deviceId) {
                            if let index = unknownBeacons.index(of: deviceId) {
                                unknownBeacons.remove(at: index)
                            }
                        }
                        nearBeacons.append(deviceId)
                    }
                case .far:
                    if farBeacons.contains(deviceId) {
                        // If beacon is already detected no need to do anything
                    } else {
                        if immediateBeacons.contains(deviceId) {
                            if let index = immediateBeacons.index(of: deviceId) {
                                immediateBeacons.remove(at: index)
                            }
                        }
                        if nearBeacons.contains(deviceId) {
                            if let index = nearBeacons.index(of: deviceId) {
                                nearBeacons.remove(at: index)
                            }
                        }
                        if unknownBeacons.contains(deviceId) {
                            if let index = unknownBeacons.index(of: deviceId) {
                                unknownBeacons.remove(at: index)
                            }
                        }
                        farBeacons.append(deviceId)
                    }
                case .unknown:
                    if unknownBeacons.contains(deviceId) {
                        // If beacon is already detected no need to do anything
                    } else {
                        if immediateBeacons.contains(deviceId) {
                            if let index = immediateBeacons.index(of: deviceId) {
                                immediateBeacons.remove(at: index)
                            }
                        }
                        if nearBeacons.contains(deviceId) {
                            if let index = nearBeacons.index(of: deviceId) {
                                nearBeacons.remove(at: index)
                            }
                        }
                        if farBeacons.contains(deviceId) {
                            if let index = farBeacons.index(of: deviceId) {
                                farBeacons.remove(at: index)
                            }
                        }
                        unknownBeacons.append(deviceId)
                    }
                }
            }
        }
    }

    private func syncBeacon(beacon: CLBeacon) -> [IBeaconDevice] {
        var b = [IBeaconDevice]() // get beacons from somewhere
        b = b.filter {
            let proximityUUID = $0.proximityUUID!
            let major = $0.major!
            let minor = $0.minor!
            // it will be called the number of time of beacons registered in the app. In example : It will be called 3 times because I have 3 beacons registered.
            if (proximityUUID.caseInsensitiveCompare(beacon.proximityUUID.uuidString) == ComparisonResult.orderedSame) && (major as NSNumber) == beacon.major && (minor as NSNumber) == beacon.minor {
                return true
            }
            return false
        }
        return b
    }

    private func triggerProximityEvent(deviceId: String, proximityEvent: ProximityEvent, completion: @escaping (_ proximityEvent: ProximityEvent?) -> Void) {
        let userCompletion = completion
        Alps.DeviceAPI.triggerProximityEvents(deviceId: deviceId, proximityEvent: proximityEvent) { (proximityEvent, _) in
            userCompletion(proximityEvent)
        }
    }

    public func startBeaconsProximityEvent(forCLProximity: CLProximity) {
        proximityTrigger.insert(forCLProximity)
        // To change the TIMERS ! https://developer.apple.com/library/content/documentation/Performance/Conceptual/power_efficiency_guidelines_osx/Timers.html Reducing overhead
    }

    public func stopBeaconsProximityEvent(forCLProximity: CLProximity) {
        proximityTrigger.remove(forCLProximity)
    }

    // TODO: improve code of method below so it matches swiftlint requirement regarding complexity + length
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    private func triggerBeaconsProximityEvent(forCLProximity: CLProximity) {
        var beacons: [String] = []
        var trigger: [String: ProximityEvent] = [:]
        var distance: Double = 0.0
        // Setting parameters upon the case
        switch forCLProximity {
        case .immediate:
            beacons = immediateBeacons
            trigger = ContextManager.immediateTrigger
            distance = 0.5
        case .near:
            beacons = nearBeacons
            trigger = ContextManager.nearTrigger
            distance = 3.0
        case .far:
            beacons = farBeacons
            trigger = ContextManager.farTrigger
            distance = 50.0
        case .unknown:
            beacons = unknownBeacons
            trigger = ContextManager.unknownTrigger
            distance = 200.0
        }
        for id in beacons {
            // Check if a proximity event already exist
            if trigger[id] == nil {
                // Send the proximity event
                let proximityEvent = ProximityEvent.init(deviceId: id, distance: distance)
                let deviceId = ""// get id from somewhere?
                triggerProximityEvent(deviceId: deviceId, proximityEvent: proximityEvent) { (_ proximityEvent) in
                    trigger[id] = proximityEvent
                    switch forCLProximity {
                    case .immediate:
                        ContextManager.immediateTrigger = trigger
                    case .near:
                        ContextManager.nearTrigger = trigger
                    case .far:
                        ContextManager.farTrigger = trigger
                    case .unknown:
                        ContextManager.unknownTrigger = trigger
                    }
                }
            } else {
                // Check if the existed proximity event needs a refresh on a based timer
                let proximityEvent = trigger[id]
                // Represents  the UNIX current time in milliseconds
                let now = Int64(Date().timeIntervalSince1970 * 1000)
                if let proximityEventCreatedAt = proximityEvent?.createdAt {
                    let gap = now - proximityEventCreatedAt
                    let truncatedGap = Int(truncatingIfNeeded: gap)
                    if truncatedGap > refreshTimer {
                        // Send the refreshing proximity event based on the timer
                        let newProximityEvent = ProximityEvent.init(deviceId: id, distance: distance)
                        let deviceId = "" // get main device id somehow
                        triggerProximityEvent(deviceId: deviceId, proximityEvent: newProximityEvent) { (_ proximityEvent) in
                            trigger[id] = proximityEvent
                            switch forCLProximity {
                            case .immediate:
                                ContextManager.immediateTrigger = trigger
                            case .near:
                                ContextManager.nearTrigger = trigger
                            case .far:
                                ContextManager.farTrigger = trigger
                            case .unknown:
                                ContextManager.unknownTrigger = trigger
                            }
                        }
                    } else {
                        // Do something when it doesn't need to be refreshed
                    }
                } else {
                    NSLog("ERROR : CreatedAt in a proximity event is nil.")
                }
            }
        }
    }

    private class func refreshTriggers() {
        var trigger: [String: ProximityEvent] = [:]

        func refresh(trigger: [String: ProximityEvent]) {
            var t: [String: ProximityEvent] = [:]
            t = trigger
            for (id, proximityEvent) in t {

                if let createdAt = proximityEvent.createdAt {
                    let now = Int64(Date().timeIntervalSince1970 * 1000)
                    let gap = now - createdAt

                    // If gap is higher than 5 minutes we will clear the value in the trigger dictionary

                    if gap > 5 * 60 * 1000 {
                        t.removeValue(forKey: id)
                        for i in 0...3 {
                            switch i {
                            case 0:
                                // unknown
                                unknownTrigger = t
                            case 1:
                                // immediate
                                immediateTrigger = t
                            case 2:
                                // near
                                nearTrigger = t
                            case 3:
                                // far
                                farTrigger = t
                            default:
                                break
                            }
                        }
                    }
                }
            }
        }

        for i in 0...3 {
            switch i {
            case 0:
                // unknown
                trigger = unknownTrigger
                refresh(trigger: trigger)
            case 1:
                // immediate
                trigger = immediateTrigger
                refresh(trigger: trigger)
            case 2:
                // near
                trigger = nearTrigger
                refresh(trigger: trigger)
            case 3:
                // far
                trigger = farTrigger
                refresh(trigger: trigger)
            default:
                NSLog("This shouldn't be printed, we are in default case.")
            }
        }
    }
}

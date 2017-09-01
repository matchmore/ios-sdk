//
//  LocationManager.swift
//  Alps
//
//  Created by Rafal Kowalski on 28.09.16.
//  Copyright © 2016 Alps. All rights reserved.
//

import Foundation
import CoreLocation
import Alps

class LocationManager: NSObject, CLLocationManagerDelegate {
    var alpsManager: AlpsManager
    var seenError = false
    var locationFixAchieved = false

    let clLocationManager: CLLocationManager

    var onLocationUpdateClosure: ((_ location: CLLocation) -> Void)?
    
    // Beacons
    // Triggered proximity event map
    var refreshTimer : Int = 60 * 1000 // timer is in milliseconds
    var proximityTrigger = Set<CLProximity>()
    // [Is the id of the IBeaconDevice registered in the core : The returned ProximityEvent will be stored ]
    var immediateTrigger : [String:ProximityEvent] = [:]
    var nearTrigger : [String:ProximityEvent] = [:]
    var farTrigger : [String:ProximityEvent] = [:]
    var unknownTrigger : [String:ProximityEvent] = [:]
    var immediateBeacons : [String] = []
    var nearBeacons : [String] = []
    var farBeacons : [String] = []
    var unknownBeacons : [String] = []
    var closestBeaconClosure: ((_ beacon: CLBeacon) -> Void)?
    var detectedBeaconsClosure: ((_ beacons: [CLBeacon]) -> Void)?

    public func onLocationUpdate(completion: @escaping (_ location: CLLocation) -> Void) {
        onLocationUpdateClosure = completion
    }

    convenience init(alpsManager: AlpsManager) {
        self.init(alpsManager: alpsManager, locationManager: CLLocationManager())
    }

    init(alpsManager: AlpsManager, locationManager: CLLocationManager) {
        self.alpsManager = alpsManager
        self.clLocationManager = locationManager
        super.init()

        self.clLocationManager.delegate = self
        self.clLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.clLocationManager.requestAlwaysAuthorization()
    }

    // Location Manager Delegate stuff
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        seenError = true
        print(error)
    }

    // Update locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = locations.last {
            do {
                try self.onLocationUpdateClosure?(locations.last!)
                try alpsManager.updateLocation(latitude: coord.coordinate.latitude, longitude: coord.coordinate.longitude,
                                             altitude: coord.altitude, horizontalAccuracy: coord.horizontalAccuracy,
                                             verticalAccuracy: coord.verticalAccuracy) {
                    (_ location) in
                    NSLog("updating location to: \(coord.coordinate.latitude), \(coord.coordinate.longitude), \(coord.altitude)")
                }
            } catch {
                // Allow to update location even when there is no device / user created
            }
        }
    }

    // authorization status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        var shouldAllow = false

        switch status {
        case .restricted, .denied, .notDetermined:
            shouldAllow = false
        default:
            shouldAllow = true
        }

        if (shouldAllow == true) {
            print("Location updates allowed")
            manager.startUpdatingLocation()
        } else {
            print("Location updates denied")
        }
    }

    func startUpdatingLocation() {
        clLocationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        clLocationManager.stopUpdatingLocation()
    }
    
    //DEVELOP: Beacons
    func startRanging(forUuid : UUID, identifier : String){
        let ourCLBeaconRegion = CLBeaconRegion.init(proximityUUID: forUuid, identifier: identifier)
        clLocationManager.startRangingBeacons(in: ourCLBeaconRegion)
    }
    
    func stopRanging(forUuid : UUID){
        for region in clLocationManager.rangedRegions{
            if let beaconRegion = region as? CLBeaconRegion {
                if forUuid.uuidString == beaconRegion.proximityUUID.uuidString {
                    clLocationManager.stopRangingBeacons(in: beaconRegion)
                    print("Stopped ranging for a beacon region")
                }
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        // Returning the closest beacon and all the detected beacons
        var closest : CLBeacon?
        if beacons.isEmpty != true {
            closest = beacons.first!
            for beacon in beacons{
                if ((closest?.accuracy)! > beacon.accuracy) {
                    closest = beacon;
                }
            }
        }
        if let closestBeacon = closest {
            do {
                // If the developer needs the closest beacon or the detected beacons, he/she can access it with these 2 fields.
                try self.closestBeaconClosure?(closestBeacon)
                    self.detectedBeaconsClosure?(beacons)
            } catch {
                // just to catch
            }
        }
        
        // Proximity Events related
        parseBeaconsByProximity(beacons)
        if proximityTrigger.isEmpty {
            // No proximity event are triggering yet since proximityTrigger array is empty
        } else {
            for pt in proximityTrigger{
                switch pt {
                case .immediate:
                    triggerBeaconsProximityEvent(forCLProximity: pt)
                    break
                case .near:
                    triggerBeaconsProximityEvent(forCLProximity: pt)
                    break
                case .far:
                    triggerBeaconsProximityEvent(forCLProximity: pt)
                    break
                case .unknown:
                    triggerBeaconsProximityEvent(forCLProximity: pt)
                    break
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        print(error)
    }
    
    
    func getClosestOnBeaconUpdate(completion: @escaping (_ beacon: CLBeacon) -> Void){
        closestBeaconClosure = completion
    }
    
    func getAllOnBeaconUpdate(completion: @escaping (_ beacons: [CLBeacon]) -> Void){
        detectedBeaconsClosure = completion
    }
    
    private func parseBeaconsByProximity(_ beacons: [CLBeacon]){
        var ourBeacon : IBeaconDevice?
        for beacon in beacons {
            let b = syncBeacon(beacon: beacon)
            if b.isEmpty != true {
                ourBeacon = b[0]
            }
            if var deviceId = ourBeacon?.id{
                switch beacon.proximity {
                case .immediate:
                    if immediateBeacons.contains(deviceId){
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
                    break
                case .near:
                    if nearBeacons.contains(deviceId){
                        // If beacon is already detected no need to do anything
                    }else {
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
                    break
                case .far:
                    if farBeacons.contains(deviceId){
                        // If beacon is already detected no need to do anything
                    }else {
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
                    break
                case .unknown:
                    if unknownBeacons.contains(deviceId){
                        // If beacon is already detected no need to do anything
                    }else{
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
                    break
                }
            }
        }
    }
    
    private func syncBeacon(beacon: CLBeacon) -> [IBeaconDevice] {
        var b : [IBeaconDevice] = self.alpsManager.beacons
        b = self.alpsManager.beacons.filter{
            let proximityUUID = $0.proximityUUID!
            let major = $0.major!
            let minor = $0.minor!
            // It will be called 3 times because I have 3 beacons registered but it will be called the number of time of beacons registered in the app.
            if (proximityUUID.caseInsensitiveCompare(beacon.proximityUUID.uuidString) == ComparisonResult.orderedSame)  && (major as NSNumber) == beacon.major && (minor as NSNumber) == beacon.minor {
                return true
            }
            return false
        }
        return b
    }
    
//    private func triggerImmediateBeaconsProximityEvent() {
//        for id in immediateBeacons{
//            // Check if a proximity event already exist
//            if immediateTrigger[id] == nil {
//                // Send the proximity event
//                var proximityEvent = ProximityEvent.init(deviceId: id, distance: 0.5)
//                let userId = self.alpsManager.alpsUser?.user.id
//                triggerProximityEvent(userId: userId!, deviceId: id, proximityEvent: proximityEvent) {
//                    (_ proximityEvent) in
//                    self.immediateTrigger[id] = proximityEvent
//                }
//            } else {
//                // Check if the existed proximity event needs a refresh on a based timer
//                let proximityEvent = immediateTrigger[id]
//                // Represents  the UNIX current time in milliseconds
//                let now = Int64(Date().timeIntervalSince1970 * 1000)
//                if let proximityEventCreatedAt = proximityEvent?.createdAt{
//                    let gap = now - proximityEventCreatedAt
//                    let truncatedGap = Int(truncatingBitPattern: gap)
//                    if truncatedGap > triggerTimer {
//                        // Send the refreshing proximity event based on the timer
//                        let newProximityEvent = ProximityEvent.init(deviceId: id, distance: 0.5)
//                        let userId = self.alpsManager.alpsUser?.user.id
//                        triggerProximityEvent(userId: userId!, deviceId: id, proximityEvent: newProximityEvent) {
//                            (_ proximityEvent) in
//                            self.immediateTrigger[id] = proximityEvent
//                        }
//                    }else{
//                        // Do something when it doesn't need to be refreshed
//                    }
//                } else {
//                    print("ERROR : CreatedAt in a proximity event is nil.")
//                }
//            }
//        }
//    }
//    
//    private func triggerNearBeaconsProximityEvent() {
//        for id in nearBeacons{
//            // Check if a proximity event already exist
//            if nearTrigger[id] == nil {
//                // Send the proximity event
//                var proximityEvent = ProximityEvent.init(deviceId: id, distance: 3.0)
//                let userId = self.alpsManager.alpsUser?.user.id
//                triggerProximityEvent(userId: userId!, deviceId: id, proximityEvent: proximityEvent) {
//                    (_ proximityEvent) in
//                    self.nearTrigger[id] = proximityEvent
//                }
//            } else {
//                // Check if the existed proximity event needs a refresh on a based timer
//                let proximityEvent = nearTrigger[id]
//                // Represents  the UNIX current time in milliseconds
//                let now = Int64(Date().timeIntervalSince1970 * 1000)
//                if let proximityEventCreatedAt = proximityEvent?.createdAt{
//                    let gap = now - proximityEventCreatedAt
//                    let truncatedGap = Int(truncatingBitPattern: gap)
//                    if truncatedGap > triggerTimer {
//                        // Send the refreshing proximity event based on the timer
//                        let newProximityEvent = ProximityEvent.init(deviceId: id, distance: 3.0)
//                        let userId = self.alpsManager.alpsUser?.user.id
//                        triggerProximityEvent(userId: userId!, deviceId: id, proximityEvent: newProximityEvent) {
//                            (_ proximityEvent) in
//                            self.nearTrigger[id] = proximityEvent
//                        }
//                    }else{
//                        // Do something when it doesn't need to be refreshed
//                    }
//                } else {
//                    print("ERROR : CreatedAt in a proximity event is nil.")
//                }
//            }
//        }
//    }
//    
//    private func triggerFarBeaconsProximityEvent() {
//        for id in farBeacons{
//            // Check if a proximity event already exist
//            if farTrigger[id] == nil {
//                // Send the proximity event
//                var proximityEvent = ProximityEvent.init(deviceId: id, distance: 50.0)
//                let userId = self.alpsManager.alpsUser?.user.id
//                triggerProximityEvent(userId: userId!, deviceId: id, proximityEvent: proximityEvent) {
//                    (_ proximityEvent) in
//                    self.farTrigger[id] = proximityEvent
//                }
//            } else {
//                // Check if the existed proximity event needs a refresh on a based timer
//                let proximityEvent = farTrigger[id]
//                // Represents  the UNIX current time in milliseconds
//                let now = Int64(Date().timeIntervalSince1970 * 1000)
//                if let proximityEventCreatedAt = proximityEvent?.createdAt{
//                    let gap = now - proximityEventCreatedAt
//                    let truncatedGap = Int(truncatingBitPattern: gap)
//                    if truncatedGap > triggerTimer {
//                        // Send the refreshing proximity event based on the timer
//                        let newProximityEvent = ProximityEvent.init(deviceId: id, distance: 50.0)
//                        let userId = self.alpsManager.alpsUser?.user.id
//                        triggerProximityEvent(userId: userId!, deviceId: id, proximityEvent: newProximityEvent) {
//                            (_ proximityEvent) in
//                            self.farTrigger[id] = proximityEvent
//                        }
//                    }else{
//                        // Do something when it doesn't need to be refreshed
//                    }
//                } else {
//                    print("ERROR : CreatedAt in a proximity event is nil.")
//                }
//            }
//        }
//    }
//    
//    private func triggerUnknownBeaconsProximityEvent() {
//        for id in unknownBeacons{
//            // Check if a proximity event already exist
//            if unknownTrigger[id] == nil {
//                // Send the proximity event
//                var proximityEvent = ProximityEvent.init(deviceId: id, distance: 200.0)
//                let userId = self.alpsManager.alpsUser?.user.id
//                triggerProximityEvent(userId: userId!, deviceId: id, proximityEvent: proximityEvent) {
//                    (_ proximityEvent) in
//                    self.unknownTrigger[id] = proximityEvent
//                }
//            } else {
//                // Check if the existed proximity event needs a refresh on a based timer
//                let proximityEvent = unknownTrigger[id]
//                // Represents  the UNIX current time in milliseconds
//                let now = Int64(Date().timeIntervalSince1970 * 1000)
//                if let proximityEventCreatedAt = proximityEvent?.createdAt{
//                    let gap = now - proximityEventCreatedAt
//                    let truncatedGap = Int(truncatingBitPattern: gap)
//                    if truncatedGap > triggerTimer {
//                        // Send the refreshing proximity event based on the timer
//                        let newProximityEvent = ProximityEvent.init(deviceId: id, distance: 200.0)
//                        let userId = self.alpsManager.alpsUser?.user.id
//                        triggerProximityEvent(userId: userId!, deviceId: id, proximityEvent: newProximityEvent) {
//                            (_ proximityEvent) in
//                            self.unknownTrigger[id] = proximityEvent
//                        }
//                    }else{
//                        // Do something when it doesn't need to be refreshed
//                    }
//                } else {
//                    print("ERROR : CreatedAt in a proximity event is nil.")
//                }
//            }
//        }
//    }
    
    private func triggerProximityEvent(userId: String, deviceId: String, proximityEvent: ProximityEvent, completion: @escaping (_ proximityEvent: ProximityEvent?) -> Void) {
        let userCompletion = completion
        let _ = Alps.DeviceAPI.triggerProximityEvents(userId: userId, deviceId: deviceId, proximityEvent: proximityEvent) {
            (proximityEvent, error) -> Void in
            
            userCompletion(proximityEvent)
        }
    }
    
    func startBeaconsProximityEvent(forCLProximity: CLProximity) {
        proximityTrigger.insert(forCLProximity)
    }
    
    func stopBeaconsProximityEvent(forCLProximity: CLProximity) {
        proximityTrigger.remove(forCLProximity)
    }
    
    private func triggerBeaconsProximityEvent(forCLProximity: CLProximity) {
        var beacons : [String] = []
        var trigger : [String:ProximityEvent] = [:]
        var distance : Double = 0.0
        // Setting parameters upon the case
        switch forCLProximity{
        case .immediate:
            beacons = immediateBeacons
            trigger = immediateTrigger
            distance = 0.5
            break
        case .near:
            beacons = nearBeacons
            trigger = nearTrigger
            distance = 3.0
            break
        case .far:
            beacons = farBeacons
            trigger = farTrigger
            distance = 50.0
            break
        case .unknown:
            beacons = unknownBeacons
            trigger = unknownTrigger
            distance = 200.0
            break
        }
        for id in beacons{
            // Check if a proximity event already exist
            if trigger[id] == nil {
                // Send the proximity event
                var proximityEvent = ProximityEvent.init(deviceId: id, distance: distance)
                let userId = self.alpsManager.alpsUser?.user.id
                triggerProximityEvent(userId: userId!, deviceId: id, proximityEvent: proximityEvent) {
                    (_ proximityEvent) in
                    trigger[id] = proximityEvent
                    switch forCLProximity{
                    case .immediate:
                        self.immediateTrigger = trigger
                        break
                    case .near:
                        self.nearTrigger = trigger
                        break
                    case .far:
                        self.farTrigger = trigger
                        break
                    case .unknown:
                        self.unknownTrigger = trigger
                        break
                    }
                }
            } else {
                // Check if the existed proximity event needs a refresh on a based timer
                let proximityEvent = trigger[id]
                // Represents  the UNIX current time in milliseconds
                let now = Int64(Date().timeIntervalSince1970 * 1000)
                if let proximityEventCreatedAt = proximityEvent?.createdAt{
                    let gap = now - proximityEventCreatedAt
                    let truncatedGap = Int(truncatingBitPattern: gap)
                    if truncatedGap > refreshTimer {
                        // Send the refreshing proximity event based on the timer
                        let newProximityEvent = ProximityEvent.init(deviceId: id, distance: distance)
                        let userId = self.alpsManager.alpsUser?.user.id
                        triggerProximityEvent(userId: userId!, deviceId: id, proximityEvent: newProximityEvent) {
                            (_ proximityEvent) in
                            trigger[id] = proximityEvent
                            switch forCLProximity{
                            case .immediate:
                                self.immediateTrigger = trigger
                                break
                            case .near:
                                self.nearTrigger = trigger
                                break
                            case .far:
                                self.farTrigger = trigger
                                break
                            case .unknown:
                                self.unknownTrigger = trigger
                                break
                            }
                        }
                    }else{
                        // Do something when it doesn't need to be refreshed
                    }
                } else {
                    print("ERROR : CreatedAt in a proximity event is nil.")
                }
            }
        }
    }
    
    private func clearTriggers() {
        var trigger : [String:ProximityEvent] = [:]
        func refresh(trigger: [String:ProximityEvent]){
            var t : [String:ProximityEvent] = [:]
            t = trigger
            for (id, proximityEvent) in t {
                
                if let createdAt = proximityEvent.createdAt {
                    let now = Int64(Date().timeIntervalSince1970 * 1000)
                    let gap = now - createdAt
                    
                    if gap > 5 * 60 * 1000 {
                        t.removeValue(forKey: id)
                        for i in 0...3 {
                            switch i{
                            case 0:
                                // unknown
                                unknownTrigger = t
                                break
                            case 1:
                                // immediate
                                immediateTrigger = t
                                break
                            case 2:
                                // near
                                nearTrigger = t
                                break
                            case 3:
                                // far
                                farTrigger = t
                                break
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
                break
            case 1:
                // immediate
                trigger = immediateTrigger
                refresh(trigger: trigger)
                break
            case 2:
                // near
                trigger = nearTrigger
                refresh(trigger: trigger)
                break
            case 3:
                // far
                trigger = farTrigger
                refresh(trigger: trigger)
                break
            default:
                print("Why are we in default ?")
                break
            }
        }
    }

}

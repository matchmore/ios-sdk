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
    var triggerTimer : Int = 5
    var proximityTrigger = Set<CLProximity>()
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
                try self.closestBeaconClosure?(closestBeacon)
                    self.detectedBeaconsClosure?(beacons)
            } catch {
                // just to catch
            }
        }
        parseBeaconsByProximity(beacons)
        for (i, o) in immediateTrigger {
            print(i)
            print(o)
        }
        if proximityTrigger.isEmpty {
            print("NO proximity event triggering yet.")
        } else {
            for pt in proximityTrigger{
                switch pt {
                case .immediate:
                    triggerImmediateBeaconsProximityEvent()
                    print("Imm")
                    break
                case .near:
                    triggerNearBeaconsProximityEvent()
                    print("NEar")
                    break
                case .far:
                    triggerFarBeaconsProximityEvent()
                    print("Far")
                    break
                case .unknown:
                    triggerUnknownBeaconsProximityEvent()
                    print("Unknown")
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
            let id = $0.id!
            let proximityUUID = $0.proximityUUID!
            let major = $0.major!
            let minor = $0.minor!
            // It will be called 3 times because I have 3 beacons registered but it will be called the number of time of beacons registered in the app.
//            print(id)
//            print(proximityUUID)
//            print(beacon.proximityUUID.uuidString)
//            print(".------")
//            print(major)
//            print(beacon.major)
//            print(".------")
//            print(minor)
//            print(beacon.minor)
//            print(".------")
            if (proximityUUID.caseInsensitiveCompare(beacon.proximityUUID.uuidString) == ComparisonResult.orderedSame)  && (major as NSNumber) == beacon.major && (minor as NSNumber) == beacon.minor {
                return true
            }
            return false
        }
        return b
    }
    
    private func triggerImmediateBeaconsProximityEvent() {
        print("... immediate ...")
        print(immediateBeacons)
        print("... near ...")
        print(nearBeacons)
        print("... far ...")
        print(farBeacons)
        print("... unknown ...")
        print(unknownBeacons)
        for id in immediateBeacons{
            // Check if a proximity event already exist
            if immediateTrigger[id] == nil {
                // Send the proximity event
                var proximityEvent = ProximityEvent.init(deviceId: id, distance: 0.5)
                let userId = self.alpsManager.alpsUser?.user.id
                triggerProximityEvent(userId: userId!, deviceId: id, proximityEvent: proximityEvent) {
                    (_ proximityEvent) in
                    print("------------------------")
                    print(proximityEvent?.id)
                    print(proximityEvent?.createdAt)
                    print(proximityEvent?.deviceId)
                    print(proximityEvent?.distance)
                    self.immediateTrigger[id] = proximityEvent
                    print("ImmediateBeacons PROXIMITY event fired, for \(String(describing: proximityEvent?.deviceId))")
                }
            } else {
                // Check if the existed proximity event needs a refresh on a based timer
                var proximityEvent = immediateTrigger[id]
                print("an already triggered proximity event, \(String(describing: proximityEvent))")
            }
        }
    }
    
    private func triggerNearBeaconsProximityEvent() {
        for id in nearBeacons{
            // Check if a proximity event already exist
            if nearTrigger[id] == nil {
                // Send the proximity event
                let p = ProximityEvent.init(deviceId: id, distance: 0.5)
                nearTrigger[id] = p
                print("NearBeacons PROXIMITY event fired, for \(String(describing:p.deviceId))")
            } else {
                // Check if the existed proximity event needs a refresh on a based timer
                let proximityEvent = nearTrigger[id]
                print("an already triggered proximity event, \(String(describing: proximityEvent))")
            }
        }
    }
    
    private func triggerFarBeaconsProximityEvent() {
        for id in farBeacons{
            // Check if a proximity event already exist
            if farTrigger[id] == nil {
                // Send the proximity event
                let p = ProximityEvent.init(deviceId: id, distance: 0.5)
                farTrigger[id] = p
                print("FarBeacons PROXIMITY event fired, for \(String(describing:p.deviceId))")
            } else {
                // Check if the existed proximity event needs a refresh on a based timer
                let proximityEvent = farTrigger[id]
                print("an already triggered proximity event, \(String(describing: proximityEvent))")
            }
        }
    }
    
    private func triggerUnknownBeaconsProximityEvent() {
        for id in unknownBeacons{
            // Check if a proximity event already exist
            if unknownTrigger[id] == nil {
                // Send the proximity event
                let p = ProximityEvent.init(deviceId: id, distance: 0.5)
                unknownTrigger[id] = p
                print("UnknownBeacons PROXIMITY event fired, for \(String(describing:p.deviceId))")
            } else {
                // Check if the existed proximity event needs a refresh on a based timer
                let proximityEvent = unknownTrigger[id]
                print("an already triggered proximity event, \(String(describing: proximityEvent))")
            }
        }
    }
    
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
}

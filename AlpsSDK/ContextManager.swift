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
    private(set) var proximityHandler: ProximityHandler!
    // id of all known beacons
    var beacons: [IBeaconTriple] = []

    init(delegate: ContextManagerDelegate) {
        super.init()
        self.delegate = delegate
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.proximityHandler = ProximityHandler(contextManager: self)
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
        // Proximity Events related
        proximityHandler.parseBeaconsByProximity(beacons)
        proximityHandler.triggerBeaconsProximityEvent()
        proximityHandler.refreshTriggers()
    }

    private func triggerProximityEvent(deviceId: String, proximityEvent: ProximityEvent, completion: @escaping (_ proximityEvent: ProximityEvent?) -> Void) {
        let userCompletion = completion
        Alps.DeviceAPI.triggerProximityEvents(deviceId: deviceId, proximityEvent: proximityEvent) { (proximityEvent, _) in
            userCompletion(proximityEvent)
        }
    }
}

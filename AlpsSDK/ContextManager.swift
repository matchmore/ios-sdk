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

public class ContextManager: NSObject, CLLocationManagerDelegate {
    
    private weak var delegate: ContextManagerDelegate?
    let proximityHandler: ProximityHandlerDelegate? = ProximityHandler()

    let locationManager = CLLocationManager()
    // id of all known beacons
    var knownBeacons: IBeaconTriples = []

    init(delegate: ContextManagerDelegate) {
        super.init()
        self.delegate = delegate
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
    }

    // MARK: - Core Location Manager Delegate

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        delegate?.contextManager(manager: self, didUpdateLocation: lastLocation)
    }

    // MARK: - Beacons
    
    func startRanging(forUuid: UUID, identifier: String) {
        let beaconRegion = CLBeaconRegion(proximityUUID: forUuid, identifier: identifier)
        locationManager.startRangingBeacons(in: beaconRegion)
    }

    public func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        delegate?.contextManager(manager: self, didDetectBeacons: beacons)
        proximityHandler?.didRangeBeacons(manager: self, beacons: beacons, knownBeacons: knownBeacons)
        if let closestBeacon = beacons.max(by: { $0.accuracy < $1.accuracy }) {
            delegate?.contextManager(manager: self, didRangeClosestBeacon: closestBeacon)
        }
    }
}

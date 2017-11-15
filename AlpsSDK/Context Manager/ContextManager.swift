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
    func didUpdateLocation(location: CLLocation)
}

public class ContextManager: NSObject, CLLocationManagerDelegate {
    
    private weak var delegate: ContextManagerDelegate?
    let proximityHandler: ProximityHandlerDelegate? = ProximityHandler()

    let locationManager = CLLocationManager()
    
    public lazy var beaconTriples = BeaconTripleRepository()

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
        delegate?.didUpdateLocation(location: lastLocation)
    }

    // MARK: - Beacons
    
    public func startRanging(forUuid: UUID, identifier: String) {
        let beaconRegion = CLBeaconRegion(proximityUUID: forUuid, identifier: identifier)
        locationManager.startRangingBeacons(in: beaconRegion)
    }

    public func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        beaconTriples.findAll { result in
            self.proximityHandler?.didRangeBeacons(manager: self, beacons: beacons, knownBeacons: result.responseObject)
        }
    }
}

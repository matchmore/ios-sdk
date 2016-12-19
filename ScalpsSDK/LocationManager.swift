//
//  LocationManager.swift
//  Scalps
//
//  Created by Rafal Kowalski on 28.09.16.
//  Copyright © 2016 Scalps. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    var seenError = false
    var locationFixAchieved = false

    let clLocationManager: CLLocationManager

    override convenience init() {
        self.init(CLLocationManager())
    }

    init(_ clLocationManager: CLLocationManager) {
        self.clLocationManager = clLocationManager
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
            print("\(coord.coordinate.latitude), \(coord.coordinate.longitude)")
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
}

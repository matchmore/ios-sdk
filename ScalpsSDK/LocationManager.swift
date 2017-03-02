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
    var scalpsManager: ScalpsManager
    var seenError = false
    var locationFixAchieved = false

    let clLocationManager: CLLocationManager

    convenience init(scalpsManager: ScalpsManager) {
        self.init(scalpsManager: scalpsManager, locationManager: CLLocationManager())
    }

    init(scalpsManager: ScalpsManager, locationManager: CLLocationManager) {
        self.scalpsManager = scalpsManager
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
            scalpsManager.updateLocation(latitude: coord.coordinate.latitude, longitude: coord.coordinate.longitude,
                                         altitude: coord.altitude, horizontalAccuracy: coord.horizontalAccuracy,
                                         verticalAccuracy: coord.verticalAccuracy) {
                (_ location) in
                NSLog("updating location to: \(coord.coordinate.latitude), \(coord.coordinate.longitude), \(coord.altitude)")
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
}

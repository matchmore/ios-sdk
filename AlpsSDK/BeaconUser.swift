//
//  BeaconUser.swift
//  AlpsSDK
//
//  Created by Wen on 03.08.17.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import Alps
import CoreLocation

class BeaconUser:NSObject {
    var alpsManager : AlpsManager
    var beacons = [DeviceBis]()
    
    init (alpsManager : AlpsManager) {
        self.alpsManager = alpsManager
        super.init()
        initBeacons()
    }
    
    private func initBeacons() {
        // create the dummy beacons and store them in beacons array.
        // beacons array will be in AlpsManager and getBeacons will make a call that construct an array of beacons.
        // but for now to make it looks like it s retrieving from api we let the beacons array in BeaconUser
        print("DUMMY Beacons ready.")
    }
    
    public func getBeacons() -> [DeviceBis]{
        return beacons
    }
}

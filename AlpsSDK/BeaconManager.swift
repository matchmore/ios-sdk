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

// BeaconUser is the middleware between our core and SDK, it works as the same as AlpsDevice etc..
// AlpsManager will call BeaconUser, which will communicate with the API.
class BeaconManager:NSObject {
    var alpsManager : AlpsManager
    var beacons = [IBeaconDevice]()
    
    init (alpsManager : AlpsManager) {
        self.alpsManager = alpsManager
        super.init()
    }
    
//    func initBeacons() {
//        // create the dummy beacons and store them in beacons array.
//        // beacons array will be in AlpsManager and getBeacons will make a call that construct an array of beacons.
//        // but for now to make it looks like it s retrieving from api we let the beacons array in BeaconUser
////        beacons.append(DeviceBis.init(mobileName: "mobile1", platform: "ios 9.0", deviceToken: "xxx", location: nil))
////        beacons.append(DeviceBis.init(mobileName: "mobile2", platform: "ios 10.0", deviceToken: "xxx", location: CLLocation.init(latitude: CLLocationDegrees(46.522076), longitude: CLLocationDegrees(6.583502))))
////        beacons.append(DeviceBis.init(pinName: "pin1", location: CLLocation.init(latitude: CLLocationDegrees(46.522076), longitude: CLLocationDegrees(6.583502))))
//        self.alpsManager.createUser("BEACON USER !") {
//            (_ user) in
//            print("-----!!!!!!!!!!!")
//            print(user)
//            if let userId = user?.id{
//                var b1 = IBeaconDevice.init(name: "beacon1 - rose", proximityUUID: "B9407F30-F5F8-466E-AFF9-25556B57FE6D", major: 21978, minor: 59907)
//                Alps.DeviceAPI.createDevice(userId: userId, device: b1) {
//                    (_ device, error) in
//                        print("------ BEACON 1 -- - -- --")
//                        print(device?.id)
//                    b1 = device as! IBeaconDevice
//                }
//                var b2 = IBeaconDevice.init(name: "beacon2 - jaune canari", proximityUUID: "B9407F30-F5F8-466E-AFF9-25556B57FE6D", major: 64575, minor: 19467)
//                Alps.DeviceAPI.createDevice(userId: userId, device: b2) {
//                    (_ device, error) in
//                    print("------ BEACON 2 -- - -- --")
//                    print(device?.id)
//                    b2 = device as! IBeaconDevice
//                }
//                var b3 = IBeaconDevice.init(name: "beacon3 - bordeau-betrave", proximityUUID: "B9407F30-F5F8-466E-AFF9-25556B57FE6D", major: 53494, minor: 28090)
//                Alps.DeviceAPI.createDevice(userId: userId, device: b3) {
//                    (_ device, error) in
//                    print("------ BEACON 3 -- - -- --")
//                    print(device?.id)
//                    b3 = device as! IBeaconDevice
//                }
//                self.beacons.append(b1)
//                self.beacons.append(b2)
//                self.beacons.append(b3)
//            }
//        }
//    }
    
    public func getBeacons() -> [IBeaconDevice]{
        return beacons
    }
    
    
}

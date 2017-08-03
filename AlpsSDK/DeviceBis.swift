//
//  DeviceBis.swift
//  AlpsSDK
//
//  Created by Wen on 03.08.17.
//  Copyright © 2017 Alps. All rights reserved.
//

//
//  DeviceBis.swift
//  Pods
//
//  Created by Wen on 03.08.17.
//
//

import Foundation
import CoreLocation

struct DeviceBis {
    //MARK: properties
    var name : String
    var deviceId : String?
    let type : DeviceType
    
    init(mobileName: String, platform : String, deviceToken: String, location : CLLocation?){
        self.name = mobileName
        self.type = .Mobile(platform: platform, deviceToken: deviceToken, location: location)
    }
    
    init(pinName: String, location : CLLocation){
        self.name = pinName
        self.type = .Pin(location: location)
    }
    
    init(beaconName: String, uuid: UUID, major: NSNumber, minor: NSNumber){
        self.name = beaconName
        self.type = .Beacon(uuid: uuid, major: major, minor: minor)
    }
    
    //MARK: Enum DeviceType
    enum DeviceType {
        case Mobile(platform:String, deviceToken: String, location : CLLocation?)
        case Pin(location:CLLocation?)
        case Beacon(uuid:UUID, major:NSNumber, minor:NSNumber)
        
        //    public func getLocation(_ type: Type) -> CLLocation{
        //    switch type {
        //    case .Mobile:
        //        return location
        //    case .Pin: break
        //    case .Beacon: break
        //    }
        //    }
        
        func getLocation() -> CLLocation? {
            switch self {
            case .Mobile( _, _, let location):
                return location!
            case .Pin(let location):
                return location!
            default :
                return nil
            }
        }
        
        func getDeviceToken() -> String? {
            switch self {
            case .Mobile( _, let deviceToken, _):
                return deviceToken
            default :
                return nil
            }
        }
    }
}

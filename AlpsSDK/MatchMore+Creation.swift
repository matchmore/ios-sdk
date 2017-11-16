//
//  MatchMore+Creation.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 15/11/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import Alps

public extension MatchMore {
    public class func createMainDevice(device: MobileDevice? = nil, completion: ((Result<MobileDevice>) -> Void)? = nil) {
        if let mainDevice = manager.mobileDevices.main {
            manager.matchMonitor.startMonitoringFor(device: mainDevice)
            completion?(.success(mainDevice))
            return
        }
        let uiDevice = UIDevice.current
        let mobileDevice = MobileDevice(name: device?.name ?? uiDevice.name,
                                        platform: device?.platform ?? uiDevice.systemName,
                                        deviceToken: device?.deviceToken ?? "",
                                        location: device?.location)
        manager.mobileDevices.create(item: mobileDevice) { (result) in
            if let mainDevice = result.responseObject {
                manager.matchMonitor.startMonitoringFor(device: mainDevice)
            }
            completion?(result)
        }
    }
    
    public class func createPublication(publication: Publication, for deviceWithId: String? = nil, completion: ((Result<Publication>) -> Void)? = nil) {
        publication.deviceId = deviceWithId ?? manager.mobileDevices.main?.id
        manager.publications.create(item: publication) { (result) in
            completion?(result)
        }
    }
    
    public class func createSubscription(subscription: Subscription, for deviceWithId: String? = nil, completion: ((Result<Subscription>) -> Void)? = nil) {
        subscription.deviceId = deviceWithId ?? manager.mobileDevices.main?.id
        manager.subscriptions.create(item: subscription) { (result) in
            completion?(result)
        }
    }
    
    public class func createPinDevice(device: PinDevice, completion: ((Result<PinDevice>) -> Void)? = nil) {
        manager.pinDevices.create(item: device) { (result) in
            if let pinDevice = result.responseObject {
                manager.matchMonitor.startMonitoringFor(device: pinDevice)
            }
            completion?(result)
        }
    }
}

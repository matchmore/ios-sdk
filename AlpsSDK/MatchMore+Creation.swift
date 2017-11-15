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
    public class func createMainDevice(device: MobileDevice? = nil, completion: ((Result<MobileDevice?>) -> Void)? = nil) {
        if let mainDevice = MatchMore.manager.mobileDevices.main {
            MatchMore.manager.matchMonitor.startMonitoringFor(device: mainDevice)
            completion?(.success(mainDevice))
            return
        }
        let uiDevice = UIDevice.current
        let mobileDevice = MobileDevice(name: device?.name ?? uiDevice.name,
                                        platform: device?.platform ?? uiDevice.systemName,
                                        deviceToken: device?.deviceToken ?? "",
                                        location: device?.location)
        MatchMore.manager.mobileDevices.create(item: mobileDevice) { (result) in
            if let mainDevice = result.responseObject {
                MatchMore.manager.matchMonitor.startMonitoringFor(device: mainDevice!)
            }
            completion?(result)
        }
    }
    
    public class func createPublication(publication: Publication, for deviceWithId: String? = nil, completion: ((Result<Publication?>) -> Void)? = nil) {
        publication.deviceId = deviceWithId ?? MatchMore.manager.mobileDevices.main?.id
        MatchMore.manager.publications.create(item: publication) { (result) in
            completion?(result)
        }
    }
    
    public class func createSubscription(subscription: Subscription, for deviceWithId: String? = nil, completion: ((Result<Subscription?>) -> Void)? = nil) {
        subscription.deviceId = deviceWithId ?? MatchMore.manager.mobileDevices.main?.id
        MatchMore.manager.subscriptions.create(item: subscription) { (result) in
            completion?(result)
        }
    }
    
    public class func createPinDevice(device: PinDevice, completion: ((Result<PinDevice?>) -> Void)? = nil) {
        MatchMore.manager.pinDevices.create(item: device) { (result) in
            completion?(result)
        }
    }
}

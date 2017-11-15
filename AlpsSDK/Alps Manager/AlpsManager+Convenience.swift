//
//  AlpsManager+Convenience.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 30/10/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import Alps

extension AlpsManager {
    public func createMainDevice(device: MobileDevice? = nil, completion: ((Result<MobileDevice?>) -> Void)? = nil) {
        if let mainDevice = mobileDevices.main {
            completion?(.success(mainDevice))
            self.matchMonitor.startMonitoringFor(device: mainDevice)
            return
        }
        let uiDevice = UIDevice.current
        let mobileDevice = MobileDevice(name: device?.name ?? uiDevice.name,
                                        platform: device?.platform ?? uiDevice.systemName,
                                        deviceToken: device?.deviceToken ?? "",
                                        location: device?.location)
        mobileDevices.create(item: mobileDevice) { (result) in
            completion?(result)
            self.matchMonitor.startMonitoringFor(device: self.mobileDevices.main!)
        }
    }
    
    public func createPublication(publication: Publication, for deviceWithId: String? = nil, completion: ((Result<Publication?>) -> Void)? = nil) {
        publication.deviceId = deviceWithId ?? mobileDevices.main?.id
        publications.create(item: publication) { (result) in
            completion?(result)
        }
    }
    
    public func createSubscription(subscription: Subscription, for deviceWithId: String? = nil, completion: ((Result<Subscription?>) -> Void)? = nil) {
        subscription.deviceId = deviceWithId ?? mobileDevices.main?.id
        subscriptions.create(item: subscription) { (result) in
            completion?(result)
        }
    }
    
    public func createPinDevice(device: PinDevice, completion: ((Result<PinDevice?>) -> Void)? = nil) {
        pinDevices.create(item: device) { (result) in
           completion?(result)
        }
    }

}

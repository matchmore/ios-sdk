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
    func createMainDevice(device: MobileDevice? = nil, completion: ((Result<MobileDevice?>) -> Void)? = nil) {
        let uiDevice = UIDevice.current
        let location = Location(latitude: 10, longitude: 10, altitude: 10, horizontalAccuracy: 10, verticalAccuracy: 10) // location will be optional in the future
        let mobileDevice = MobileDevice(name: device?.name ?? uiDevice.name,
                                        platform: device?.platform ?? uiDevice.systemName,
                                        deviceToken: device?.deviceToken ?? "",
                                        location: device?.location ?? location)
        mobileDevices.create(item: mobileDevice) { (result) in
            completion?(result)
        }
    }
    
    func createPublication(publication: Publication, for deviceWithId: String? = nil, completion: ((Result<Publication?>) -> Void)? = nil) {
        publication.deviceId = deviceWithId ?? mobileDevices.main?.id
        publications.create(item: publication) { (result) in
            completion?(result)
        }
    }
    
    func createSubscription(subscription: Subscription, for deviceWithId: String? = nil, completion: ((Result<Subscription?>) -> Void)? = nil) {
        subscription.deviceId = deviceWithId ?? mobileDevices.main?.id
        subscriptions.create(item: subscription) { (result) in
            completion?(result)
        }
    }
}

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
    
    /// Creates or reuses cached mobile device object. Mobile device object is used to represent the smartphone.
    ///
    /// - Parameters:
    ///   - device: (Optional) Device object that will be created on MatchMore's cloud. When device is `nil` this function will use `UIDevice.current` properties to create new Mobile Device.
    ///   - completion: Callback that returns response from the MatchMore cloud.
    public class func startUsingMainDevice(device: MobileDevice? = nil, completion: @escaping ((Result<MobileDevice>) -> Void)) {
        if let mainDevice = manager.mobileDevices.main, device == nil {
            manager.matchMonitor.startMonitoringFor(device: mainDevice)
            completion(.success(mainDevice))
            return
        }
        let uiDevice = UIDevice.current
        let mobileDevice = MobileDevice(name: device?.name ?? uiDevice.name,
                                        platform: device?.platform ?? uiDevice.systemName,
                                        deviceToken: device?.deviceToken ?? deviceToken ?? "",
                                        location: device?.location ?? lastLocation)
        manager.mobileDevices.create(item: mobileDevice) { (result) in
            if let mainDevice = result.responseObject {
                manager.matchMonitor.startMonitoringFor(device: mainDevice)
            }
            completion(result)
        }
    }
    
    /// Creates new publication attached to either main device or given device.
    ///
    /// - Parameters:
    ///   - publication: Publication object that will be created on MatchMore's cloud.
    ///   - deviceWithId: (Optional) Unique id of the device on which publication is supposed to be created. When set to `nil` it will used main mobile device that represents the smartphone.
    ///   - completion: Callback that returns response from the MatchMore cloud.
    public class func createPublication(publication: Publication, for deviceWithId: String? = nil, completion: @escaping ((Result<Publication>) -> Void)) {
        publication.deviceId = deviceWithId ?? manager.mobileDevices.main?.id
        manager.publications.create(item: publication) { (result) in
            completion(result)
        }
    }
    
    /// Creates new publication attached to either main device or given device.
    ///
    /// - Parameters:
    ///   - subscription: Subscription object that will be created on MatchMore's cloud.
    ///   - deviceWithId: (Optional) Unique id of the device on which subscriptions is supposed to be created. When set to `nil` it will used main mobile device that represents the smartphone.
    ///   - completion: Callback that returns response from the MatchMore cloud.
    public class func createSubscription(subscription: Subscription, for deviceWithId: String? = nil, completion: @escaping ((Result<Subscription>) -> Void)) {
        subscription.deviceId = deviceWithId ?? manager.mobileDevices.main?.id
        manager.subscriptions.create(item: subscription) { (result) in
            completion(result)
        }
    }
    
    /// Creates new pin device. Device created this way can be accessed via pin devices store: `MatchMore.pinDevices` or through callback's `Result`.
    ///
    /// - Parameters:
    ///   - device: Pin device object that will be created on MatchMore's cloud.
    ///   - completion: Callback that returns response from the MatchMore cloud.
    public class func createPinDevice(pinDevice: PinDevice, completion: @escaping ((Result<PinDevice>) -> Void)) {
        manager.pinDevices.create(item: pinDevice) { (result) in
            if let pinDevice = result.responseObject {
                // manager.matchMonitor.startMonitoringFor(device: pinDevice)
            }
            completion(result)
        }
    }
}

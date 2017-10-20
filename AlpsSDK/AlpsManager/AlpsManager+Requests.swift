//
//  AlpsManager+Requests.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 18/10/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import Alps

extension AlpsManager {
    // Create Main device, this function replace createDevice in v 0.0.3
    // TODO: possibly minimize number of arguments or fix swiftlint config
    // swiftlint:disable function_parameter_count
    public func createMobileDevice(name: String, platform: String, deviceToken: String,
                                   latitude: Double, longitude: Double, altitude: Double,
                                   horizontalAccuracy: Double, verticalAccuracy: Double,
                                   completion: @escaping (_ device: MobileDevice?) -> Void) {
        let userCompletion = completion
        let location = Location.init(latitude: latitude, longitude: longitude, altitude: altitude, horizontalAccuracy: horizontalAccuracy, verticalAccuracy: verticalAccuracy)
        let mobileDevice = MobileDevice.init(name: name, platform: platform, deviceToken: deviceToken, location: location)
        Alps.DeviceAPI.createDevice(device: mobileDevice) { (mobileDevice, _) -> Void in
            if mobileDevice is MobileDevice {
                if let d = mobileDevice as? MobileDevice {
                    self.devices.append(d)
                    self.publications[d.id!] = [Publication]()
                    self.subscriptions[d.id!] = [Subscription]()
                }
                userCompletion(mobileDevice as? MobileDevice)
            }
        }
    }
    
    // Create a pinned Device, stays at the same location
    public func createPinDevice(name: String, latitude: Double, longitude: Double, altitude: Double,
                                horizontalAccuracy: Double, verticalAccuracy: Double,
                                completion: @escaping (_ device: PinDevice?) -> Void) {
        let location = Location.init(latitude: latitude, longitude: longitude, altitude: altitude, horizontalAccuracy: horizontalAccuracy, verticalAccuracy: verticalAccuracy)
        let pinDevice = PinDevice.init(name: name, location: location)
        Alps.DeviceAPI.createDevice(device: pinDevice) { (pinDevice, error) -> Void in
            if let d = pinDevice as? PinDevice {
                self.devices.append(d)
                self.publications[d.id!] = [Publication]()
                self.subscriptions[d.id!] = [Subscription]()
            }
            completion(pinDevice as? PinDevice)
        }
    }
    
    // Create a BLE iBeacon Device
    public func createIBeaconDevice(name: String, proximityUUID: String, major: NSNumber, minor: NSNumber,
                                    completion: @escaping (_ device: IBeaconDevice?) -> Void) {
        let iBeaconDevice = IBeaconDevice.init(name: name, proximityUUID: proximityUUID, major: major, minor: minor)
        Alps.DeviceAPI.createDevice(device: iBeaconDevice) { (iBeaconDevice, _) -> Void in
            if iBeaconDevice is IBeaconDevice {
                if let d = iBeaconDevice as? IBeaconDevice {
                    self.devices.append(d)
                    self.publications[d.id!] = [Publication]()
                    self.subscriptions[d.id!] = [Subscription]()
                }
                completion(iBeaconDevice as? IBeaconDevice)
            }
        }
    }
    
    // create a publication for the main device
    public func createPublication(topic: String, range: Double, duration: Double, properties: [String: String],
                                  completion: @escaping (_ publication: Publication?) -> Void) {
        if let deviceId = mainDevice?.id {
            let publication = Publication(deviceId: deviceId, topic: topic, range: range, duration: duration, properties: properties)
            Alps.DeviceAPI.createPublication(deviceId: deviceId, publication: publication) { (publication, _) -> Void in
                if let p = publication {
                    self.publications[deviceId]?.append(p)
                }
                completion(publication)
            }
        } else {
            NSLog("Error forcing userId or/and deviceId is nil.")
        }
    }
    
    // Create a publication for the given userId and given deviceId
    public func createPublication(userId: String, deviceId: String, topic: String, range: Double, duration: Double, properties: [String: String],
                                  completion: @escaping (_ publication: Publication?) -> Void) {
        let userCompletion = completion
        let publication = Publication.init(deviceId: deviceId, topic: topic, range: range, duration: duration, properties: properties)
        Alps.DeviceAPI.createPublication(deviceId: deviceId, publication: publication) { (publication, _) -> Void in
            if let p = publication {
                self.publications[deviceId]?.append(p)
            }
            userCompletion(publication)
        }
    }
    
    // Create subscription for main device
    public func createSubscription(topic: String, selector: String, range: Double, duration: Double,
                                   completion: @escaping (_ subscription: Subscription?) -> Void) {
        if let deviceId = mainDevice?.id {
            let subscription = Subscription.init(deviceId: deviceId, topic: topic, range: range, duration: duration, selector: selector)
            Alps.DeviceAPI.createSubscription(deviceId: deviceId, subscription: subscription) { (subscription, _) -> Void in
                if let p = subscription {
                    self.subscriptions[deviceId]?.append(p)
                }
                completion(subscription)
            }
        } else {
            NSLog("Error forcing userId or/and deviceId is nil.")
        }
    }
    
    // Create a subscription for the given userId and given deviceId
    public func createSubscription(userId: String, deviceId: String, topic: String, selector: String, range: Double, duration: Double,
                                   completion: @escaping (_ subscription: Subscription?) -> Void) {
        let subscription = Subscription(deviceId: deviceId, topic: topic, range: range, duration: duration, selector: selector)
        Alps.DeviceAPI.createSubscription(deviceId: deviceId, subscription: subscription) { (subscription, _) -> Void in
            if let p = subscription {
                self.subscriptions[deviceId]?.append(p)
            }
            completion(subscription)
        }
    }
    
    public func updateLocation(userId: String, deviceId: String, latitude: Double, longitude: Double, altitude: Double,
                               horizontalAccuracy: Double, verticalAccuracy: Double,
                               completion: @escaping (_ location: Location?) -> Void) {
        let location = Location(latitude: latitude, longitude: longitude, altitude: altitude, horizontalAccuracy: horizontalAccuracy, verticalAccuracy: verticalAccuracy)
        Alps.DeviceAPI.createLocation(deviceId: deviceId, location: location) { (location, _) -> Void in
            completion(location)
        }
    }
    
    // Update main device location
    public func updateLocation(latitude: Double, longitude: Double, altitude: Double,
                               horizontalAccuracy: Double, verticalAccuracy: Double,
                               completion: @escaping (_ location: Location?) -> Void) {
        let location = Location(latitude: latitude, longitude: longitude, altitude: altitude, horizontalAccuracy: horizontalAccuracy, verticalAccuracy: verticalAccuracy)
        if let deviceId = mainDevice?.id {
            Alps.DeviceAPI.createLocation(deviceId: deviceId, location: location) { (location, _) -> Void in
                if let l = location {
                    self.locations[deviceId] = l
                }
                completion(location)
            }
        } else {
            NSLog("Alps user and/or device has no id !")
        }
    }
    
    public func getAllMatches(userId: String, deviceId: String, completion: @escaping (_ matches: Matches) -> Void) {
        Alps.DeviceAPI.getMatches(deviceId: deviceId) { (matches, _) -> Void in
            completion(matches ?? [])
        }
    }
    
    // Get all matches for main device
    public func getAllMatches(completion: @escaping (_ matches: Matches) -> Void) {
        if let deviceId = mainDevice?.id {
            Alps.DeviceAPI.getMatches(deviceId: deviceId) { (matches, _) -> Void in
                completion(matches ?? [])
            }
        } else {
            NSLog("Error forcing userId or/and deviceId is nil.")
        }
    }
    
    public func getDevice(_ deviceId: String, completion: @escaping (_ device: Device) -> Void) {
        Alps.DeviceAPI.getDevice(deviceId: deviceId) { (device, _) -> Void in
            if let d = device {
                completion(d)
            }
        }
    }
    
    public func getPublication(_ userId: String, deviceId: String, publicationId: String, completion: @escaping (_ publication: Publication) -> Void) {
        Alps.PublicationAPI.getPublication(deviceId: deviceId, publicationId: publicationId) { (publication, _) -> Void in
            if let p = publication {
                completion(p)
            } else {
                NSLog("This publication doesn't exist!")
            }
        }
    }
    
    public func deletePublication(_ userId: String, deviceId: String, publicationId: String, completion: @escaping () -> Void) {
        Alps.PublicationAPI.deletePublication(deviceId: deviceId, publicationId: publicationId) { (error) -> Void in
            if error != nil {
                NSLog("Impossible to delete the publication!")
            } else {
                if let index = self.publications[deviceId]?.index(where: { $0.id == publicationId }) {
                    self.publications[deviceId]?.remove(at: index)
                }
                completion()
            }
        }
    }
    
    public func getAllPublicationsForDevice(_ userId: String, deviceId: String, completion: @escaping (_ publications: [Publication]) -> Void) {
        Alps.PublicationAPI.getPublications(deviceId: deviceId) { (publications, _) -> Void in
            if let p = publications {
                completion(p)
            } else {
                NSLog("Can't find publications for this device")
            }
        }
    }
    
    public func getSubscription(_ userId: String, deviceId: String, subscriptionId: String, completion: @escaping (_ subscription: Subscription) -> Void) {
        Alps.SubscriptionAPI.getSubscription(deviceId: deviceId, subscriptionId: subscriptionId) { (subscription, _) -> Void in
            if let s = subscription {
                completion(s)
            } else {
                NSLog("This subscription doesn't exist!")
            }
        }
    }
    
    public func deleteSubscription(_ userId: String, deviceId: String, subscriptionId: String, completion: @escaping () -> Void) {
        Alps.SubscriptionAPI.deleteSubscription(deviceId: deviceId, subscriptionId: subscriptionId) { (error) -> Void in
            if error != nil {
                NSLog("Impossible to delete the subscription!")
            } else {
                if let index = self.subscriptions[deviceId]?.index(where: { $0.id == subscriptionId }) {
                    self.subscriptions[deviceId]?.remove(at: index)
                }
                completion()
            }
        }
    }
    
    public func getAllSubscriptionsForDevice(_ userId: String, deviceId: String, completion: @escaping (_ subscriptions: [Subscription]) -> Void) {
        Alps.SubscriptionAPI.getSubscriptions(deviceId: deviceId) { (subscriptions, _) -> Void in
            if let s = subscriptions {
                completion(s)
            } else {
                NSLog("Can't find subscriptions for this device")
            }
        }
    }
}

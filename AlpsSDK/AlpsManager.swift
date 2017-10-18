//
//  AlpsManager.swift
//  Alps
//
//  Created by Rafal Kowalski on 04/10/2016
//  Copyright © 2016 Alps. All rights reserved.
//

import Foundation
import CoreLocation
import Alps

enum AlpsManagerError: Error {
    case userNotIntialized
    case deviceNotInitialized
}

open class AlpsManager: AlpsSDK {

    let defaultHeaders = [
        // FIXME: pass both keys on AlpsManager creation
        "api-key": "833ec460-c09d-11e6-9bb0-cfb02086c30d",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "user-agent": "\(UIDevice().systemName) \(UIDevice().systemVersion)"
    ]

    let headers: [String: String]

    // XXX: this has to come from a configuration
    let alpsEndpoint = "https://api.matchmore.io/v4"
    // let alpsEndpoint = "http://localhost:9000"

    // Put setup code here. This method is called before the invocation of each test method in t
    let apiKey: String
    var contextManager: ContextManager?
    var matchMonitor: MatchMonitor?

    // FIXME: add the world id when it's there
    // var world: World
    var alpsUser: AlpsUser?
    var devices: [Device] = []
    var alpsDevice: AlpsDevice?
    var locations: [String: Location] = [:]
    var publications: [String: [Publication]] = [:]
    var subscriptions: [String: [Subscription]] = [:]
//    var publications: [Publication] = []
//    var subscriptions: [Subscription] = []

    // DEVELOP: Beacons
    // depending on the case beacons will have different class in his array
    // Variant 1 is enum => Device with DeviceType
    // Variant 2 is sub-classes => BeaconDevice
    // Variant 3 is protocol => BeaconDevice
    var beacons: [IBeaconDevice] = []

    public convenience init(apiKey: String) {
        self.init(apiKey: apiKey, clLocationManager: CLLocationManager())
    }

    public init(apiKey: String, clLocationManager: CLLocationManager) {
        self.apiKey = apiKey
        self.headers = defaultHeaders.merged(with: ["api-key": apiKey])
        self.contextManager = ContextManager(alpsManager: self, locationManager: clLocationManager)
        self.matchMonitor = MatchMonitor(alpsManager: self)

        AlpsAPI.basePath = alpsEndpoint
        AlpsAPI.customHeaders = headers

        // DEVELOP: Beacons
        superGetBeacons(completion: { (_ beacons) in
            self.beacons = beacons
        })
    }

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
                    self.alpsDevice = AlpsDevice(manager: self, device: self.devices[0])
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
        Alps.DeviceAPI.createDevice(device: pinDevice) { (pinDevice, _) -> Void in
            if pinDevice is PinDevice {
                if let d = pinDevice as? PinDevice {
                    self.devices.append(d)
                    self.publications[d.id!] = [Publication]()
                    self.subscriptions[d.id!] = [Subscription]()
                }
                completion(pinDevice as? PinDevice)
            }
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
        if let deviceId = alpsDevice?.device.id {
            let publication = Publication(deviceId: deviceId, topic: topic, range: range, duration: duration, properties: properties)
            Alps.DeviceAPI.createPublication(deviceId: deviceId, publication: publication) { (publication, _) -> Void in
                if let p = publication {
                    self.publications[deviceId]?.append(p)
                }
                completion(publication)
            }
        } else {
            print("Error forcing userId or/and deviceId is nil.")
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
        if let deviceId = alpsDevice?.device.id {
            let subscription = Subscription.init(deviceId: deviceId, topic: topic, range: range, duration: duration, selector: selector)
            Alps.DeviceAPI.createSubscription(deviceId: deviceId, subscription: subscription) { (subscription, _) -> Void in
                if let p = subscription {
                    self.subscriptions[deviceId]?.append(p)
                }
                completion(subscription)
            }
        } else {
            print("Error forcing userId or/and deviceId is nil.")
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
        if let deviceId = alpsDevice?.device.id {
            Alps.DeviceAPI.createLocation(deviceId: deviceId, location: location) { (location, _) -> Void in
                if let l = location {
                    self.locations[deviceId] = l
                }
                completion(location)
            }
        } else {
            print("Alps user and/or device has no id !")
        }
    }

    public func getAllMatches(userId: String, deviceId: String, completion: @escaping (_ matches: Matches) -> Void) {
        Alps.DeviceAPI.getMatches(deviceId: deviceId) { (matches, _) -> Void in
            completion(matches ?? [])
        }
    }

    // Get all matches for main device
    public func getAllMatches(completion: @escaping (_ matches: Matches) -> Void) {
        if let deviceId = alpsDevice?.device.id {
            Alps.DeviceAPI.getMatches(deviceId: deviceId) { (matches, _) -> Void in
                completion(matches ?? [])
            }
        } else {
            print("Error forcing userId or/and deviceId is nil.")
        }
    }

    // register match handlers
    public func onMatch(completion: @escaping (_ match: Match) -> Void) {
        matchMonitor?.onMatch = completion
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
                print("This publication doesn't exist!")
            }
        }
    }

    public func deletePublication(_ userId: String, deviceId: String, publicationId: String, completion: @escaping () -> Void) {
        Alps.PublicationAPI.deletePublication(deviceId: deviceId, publicationId: publicationId) { (error) -> Void in
            if error != nil {
                print("Impossible to delete the publication!")
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
                print("Can't find publications for this device")
            }
        }
    }

    public func getSubscription(_ userId: String, deviceId: String, subscriptionId: String, completion: @escaping (_ subscription: Subscription) -> Void) {
        Alps.SubscriptionAPI.getSubscription(deviceId: deviceId, subscriptionId: subscriptionId) { (subscription, _) -> Void in
            if let s = subscription {
                completion(s)
            } else {
                print("This subscription doesn't exist!")
            }
        }
    }

    public func deleteSubscription(_ userId: String, deviceId: String, subscriptionId: String, completion: @escaping () -> Void) {
        Alps.SubscriptionAPI.deleteSubscription(deviceId: deviceId, subscriptionId: subscriptionId) { (error) -> Void in
            if error != nil {
                print("Impossible to delete the subscription!")
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
                print("Can't find subscriptions for this device")
            }
        }
    }

    public func onLocationUpdate(completion: @escaping ((_ location: CLLocation) -> Void)) {
        if let lm = contextManager {
            lm.onLocationUpdate(completion: completion)
        }
    }

    public func startMonitoringMatches() {
        if let mm = matchMonitor {
            mm.startMonitoringMatches()
        }
    }

    public func stopMonitoringMatches() {
        if let mm = matchMonitor {
            mm.stopMonitoringMatches()
        }
    }

    public func startUpdatingLocation() {
        contextManager?.startUpdatingLocation()
    }

    public func stopUpdatingLocation() {
        contextManager?.stopUpdatingLocation()
    }

    public func getClosestOnBeaconUpdate(completion: @escaping ((_ beacon: CLBeacon) -> Void)) {
        if let cm = contextManager {
            cm.getClosestOnBeaconUpdate(completion: completion)
        }
    }

    public func getAllOnBeaconUpdate(completion: @escaping ((_ beacon: [CLBeacon]) -> Void)) {
        if let cm = contextManager {
            cm.getAllOnBeaconUpdate(completion: completion)
        }
    }

    public func startRangingBeacons(forUuid: UUID, identifier: String) {
        contextManager?.startRanging(forUuid: forUuid, identifier: identifier)
    }

    public func stopRangingBeacons(forUuid: UUID) {
        contextManager?.stopRanging(forUuid: forUuid)
    }

    public func startBeaconsProximityEvent(forCLProximity: CLProximity) {
        contextManager?.startBeaconsProximityEvent(forCLProximity: forCLProximity)
    }

    public func stopBeaconsProximityEvent(forCLProximity: CLProximity) {
        contextManager?.stopBeaconsProximityEvent(forCLProximity: forCLProximity)
    }

    // Default time to refresh is 60 seconds(= 60'000 milliseconds)
    public func setRefreshTimerForProximityEvent(refreshEveryInMilliseconds: Int) {
        contextManager?.refreshTimer = refreshEveryInMilliseconds
    }

    private func superGetBeacons(completion: @escaping ((_ beacons: [IBeaconDevice]) -> Void)) {
        print("to be implemented")
    }

    public func getMainDevice() -> Device? {
        var device: Device?
        if let d = alpsDevice {
            device = d.device
        } else {
            print("Alps device doesn't exist!")
        }
        return device
    }

    public func getAllDevicesMainUser() -> [Device] {
        return devices
    }

    public func getAllLocationsMainUser() -> [String: Location] {
        return locations
    }

    public func getAllPublicationsMainUser(completion: @escaping (_ publications: [String: [Publication]]) -> Void) {
        if alpsUser != nil, alpsDevice != nil {
            // XXX: ignore the returned device for now
            completion(publications)
        }
    }

    public func getAllSubscriptionsMainUser(completion: @escaping (_ subscriptions: [String: [Subscription]]) -> Void) {
        if alpsUser != nil, alpsDevice != nil {
            // XXX: ignore the returned device for now
            completion(subscriptions)
        }
    }

    public func getExistingBeacons() -> [IBeaconDevice] {
        return beacons
    }

}

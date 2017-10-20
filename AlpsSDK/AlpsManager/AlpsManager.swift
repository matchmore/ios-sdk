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

open class AlpsManager {

    // Put setup code here. This method is called before the invocation of each test method in t
    let apiKey: String
    private var contextManager: ContextManager?
    private var matchMonitor: MatchMonitor?

    var devices: [Device] = []
    var mainDevice: Device? {
        return devices.first
    }
    
    var locations = [String: Location]()
    var publications = [String: [Publication]]()
    var subscriptions = [String: [Subscription]]()

    // DEVELOP: Beacons
    // depending on the case beacons will have different class in his array
    // Variant 1 is enum => Device with DeviceType
    // Variant 2 is sub-classes => BeaconDevice
    // Variant 3 is protocol => BeaconDevice
    var beacons = [IBeaconDevice]()

    public convenience init(apiKey: String) {
        self.init(apiKey: apiKey, clLocationManager: CLLocationManager())
    }

    private init(apiKey: String, clLocationManager: CLLocationManager) {
        self.apiKey = apiKey
        self.contextManager = ContextManager(alpsManager: self, locationManager: clLocationManager)
        self.matchMonitor = MatchMonitor(alpsManager: self)
        self.setupAPI()
        
        // DEVELOP: Beacons
        superGetBeacons(completion: { (_ beacons) in
            self.beacons = beacons
        })
    }
    
    private func setupAPI() {
        let device = UIDevice.current
        let headers = [
            "api-key": self.apiKey,
            "Content-Type": "application/json; charset=UTF-8",
            "Accept": "application/json",
            "user-agent": "\(device.systemName) \(device.systemVersion)"
        ]
        AlpsAPI.customHeaders = headers
        AlpsAPI.basePath = "https://api.matchmore.io/v5"
    }
    
    // register match handlers
    public func onMatch(completion: @escaping (_ match: Match) -> Void) {
        matchMonitor?.onMatch = completion
    }

    public func onLocationUpdate(completion: @escaping ((_ location: CLLocation) -> Void)) {
        contextManager?.onLocationUpdate(completion: completion)
    }

    public func startMonitoringMatches() {
        matchMonitor?.startMonitoringMatches()
    }

    public func stopMonitoringMatches() {
        matchMonitor?.stopMonitoringMatches()
    }

    public func startUpdatingLocation() {
        contextManager?.startUpdatingLocation()
    }

    public func stopUpdatingLocation() {
        contextManager?.stopUpdatingLocation()
    }

    public func getClosestOnBeaconUpdate(completion: @escaping ((_ beacon: CLBeacon) -> Void)) {
        contextManager?.getClosestOnBeaconUpdate(completion: completion)
    }

    public func getAllOnBeaconUpdate(completion: @escaping ((_ beacon: [CLBeacon]) -> Void)) {
        contextManager?.getAllOnBeaconUpdate(completion: completion)
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
        NSLog("to be implemented")
    }

    public func getAllPublicationsMainUser(completion: @escaping (_ publications: [String: [Publication]]) -> Void) {
        if mainDevice != nil {
            // XXX: ignore the returned device for now
            completion(publications)
        }
    }

    public func getAllSubscriptionsMainUser(completion: @escaping (_ subscriptions: [String: [Subscription]]) -> Void) {
        if mainDevice != nil {
            // XXX: ignore the returned device for now
            completion(subscriptions)
        }
    }
}

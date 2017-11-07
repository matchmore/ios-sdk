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

open class AlpsManager: MatchMonitorDelegate, ContextManagerDelegate, RemoteNotificationManagerDelegate {
    let apiKey: String
    var baseURL: String {
        set {
            AlpsAPI.basePath = newValue
        } get {
            return AlpsAPI.basePath
        }
    }
    
    lazy var contextManager = ContextManager(delegate: self)
    lazy var matchMonitor = MatchMonitor(delegate: self)
    lazy var remoteNotificationManager = RemoteNotificationManager(delegate: self)
    var onMatch: ((_ matches: [Match], _ device: Device) -> Void)?
    
    lazy var mobileDevices = MobileDeviceRepository()
    lazy var pinDevices = PinDeviceRepository()
    
    lazy var publications = PublicationRepository()
    lazy var subscriptions = SubscriptionRepository()
    
    lazy var locationUpdateManager = LocationUpdateManager()

    public init(apiKey: String, baseUrl: String? = nil) {
        self.apiKey = apiKey
        self.setupAPI()
        if let baseUrl = baseUrl {
            self.baseURL = baseUrl
        }
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
    }
    
    // MARK: - Match Monitor Delegate
    
    func didFind(matches: [Match], for device: Device) {
        onMatch?(matches, device)
    }
    
    // MARK: - Context Manager Delegate
    
    func contextManager(manager monitor: ContextManager, didUpdateLocation: CLLocation) {
        mobileDevices.findAll { (result) in
            guard case let .success(mobileDevices) = result else { return }
            mobileDevices.forEach {
                guard let deviceId = $0.id else { return }
                self.locationUpdateManager.tryToSend(location: Location(location: didUpdateLocation), for: deviceId)
            }
        }
    }
    
    func contextManager(manager: ContextManager, didRangeClosestBeacon: CLBeacon) {
        
    }
    
    func contextManager(manager: ContextManager, didDetectBeacons: [CLBeacon]) {
        
    }
    
    // MARK: - Remote Notification Manager Delegate
    
    func remoteNotificationManager(manager: RemoteNotificationManager, registerDeviceToken: Data) {
        manager.registerDeviceToken(deviceToken: registerDeviceToken)
    }
    
    func remoteNotificationManager(manager: RemoteNotificationManager, handleRemoteNotification: [AnyHashable: Any]) {
        manager.handleRemoteNotification(userInfo: handleRemoteNotification)
    }
}

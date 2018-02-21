//
//  AlpsManager.swift
//  Alps
//
//  Created by Rafal Kowalski on 04/10/2016
//  Copyright © 2018 Matchmore SA. All rights reserved.
//

import CoreLocation
import Foundation
import UIKit

public typealias OnMatchClosure = (_ matches: [Match], _ device: Device) -> Void
public protocol MatchDelegate: class {
    var onMatch: OnMatchClosure? { get }
}

public class AlpsManager: MatchMonitorDelegate, ContextManagerDelegate {
    public var delegates = MulticastDelegate<MatchDelegate>()
    
    let apiKey: String
    var baseURL: String {
        set {
            AlpsAPI.basePath = newValue
        } get {
            return AlpsAPI.basePath
        }
    }
    
    lazy var contextManager = ContextManager(delegate: self)
    lazy var matchMonitor = MatchMonitor(delegate: self) // move delegates
    
    var remoteNotificationManager: RemoteNotificationManager!
    
    lazy var mobileDevices: MobileDeviceStore = {
        let mobileDevices = MobileDeviceStore()
        mobileDevices.delegates += publications
        mobileDevices.delegates += subscriptions
        return mobileDevices
    }()
    
    lazy var pinDevices: PinDeviceStore = {
        let pinDevices = PinDeviceStore()
        pinDevices.delegates += publications
        pinDevices.delegates += subscriptions
        return pinDevices
    }()
    
    lazy var publications = PublicationStore()
    lazy var subscriptions = SubscriptionStore()
    
    lazy var locationUpdateManager = LocationUpdateManager()

    internal init(apiKey: String, baseURL: String? = nil) {
        self.apiKey = apiKey
        self.setupAPI()
        if let baseURL = baseURL {
            self.baseURL = baseURL
        }
        remoteNotificationManager = RemoteNotificationManager(delegate: matchMonitor)
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
        delegates.invoke { $0.onMatch?(matches, device) }
    }
    
    // MARK: - Context Manager Delegate
    
    func didUpdateLocation(location: CLLocation) {
        mobileDevices.findAll { (result) in
            result.forEach {
                guard let deviceId = $0.id else { return }
                self.locationUpdateManager.tryToSend(location: Location(location: location), for: deviceId)
            }
        }
    }

}

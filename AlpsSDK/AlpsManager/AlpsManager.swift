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

open class AlpsManager: MatchMonitorDelegate, ContextManagerDelegate {
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
    
    lazy var mobileDeviceRepository = MobileDeviceRepository()
    lazy var deviceRepository = DeviceRepository()
    
    lazy var pubRepository = PublicationRepository()
    lazy var subRepository = SubscriptionRepository()
    
    var mainDevice: Device?

    init(apiKey: String, baseUrl: String? = nil) {
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
        AlpsAPI.basePath = "https://api.matchmore.io/v5"
    }
    
    func createMainDevice(device: MobileDevice? = nil, completion: ((MobileDevice?) -> Void)? = nil) {
        let uiDevice = UIDevice.current
        let mobileDevice = MobileDevice(name: device?.name ?? uiDevice.name,
                              platform: device?.platform ?? uiDevice.systemName,
                              deviceToken: device?.deviceToken ?? "",
                              location: device?.location ?? nil)
        mobileDeviceRepository.create(item: mobileDevice) { [weak self] (result) in
            if case let .success(createdDevice) = result {
                self?.mainDevice = createdDevice
                completion?(createdDevice)
            }
        }
    }
    
    // MARK: - Match Monitor Delegate
    
    func didFind(matches: [Match], for device: Device) {
        
    }
    
    // MARK: - Context Manager Delegate
    
    func contextManager(manager monitor: ContextManager, didUpdateLocation: CLLocation) {
        
    }
    
    func contextManager(manager: ContextManager, didRangeClosestBeacon: CLBeacon) {
        
    }
    
    func contextManager(manager: ContextManager, didDetectBeacons: [CLBeacon]) {
        
    }
}

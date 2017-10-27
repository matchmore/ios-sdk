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
    lazy var contextManager = ContextManager(delegate: self)
    lazy var matchMonitor = MatchMonitor(delegate: self)
    
    lazy var deviceRepository = DeviceRepository()
    lazy var pubRepository = PublicationRepository()
    lazy var subRepository = SubscriptionRepository()
    
    private var _mainDevice: Device?
    var mainDevice: Device? {
        if _mainDevice != nil {
            return _mainDevice
        } else {
            createMainDevice()
            return nil
        }
    }

    private init(apiKey: String) {
        self.apiKey = apiKey
        self.setupAPI()
        self.createMainDevice()
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
    
    private func createMainDevice() {
        let mainDevice = Device()
        deviceRepository.create(item: mainDevice) { [weak self] (result) in
            if case let .success(device) = result {
                self?._mainDevice = device
            }
        }
    }
    
    // MARK: - Match Monitor Delegate
    
    func matchMonitor(monitor: MatchMonitor, didReceiveMatches: [Match]) {
        
    }
    
    // MARK: - Context Manager Delegate
    
    func contextManager(manager monitor: ContextManager, didUpdateLocation: CLLocation) {
        
    }
    
    func contextManager(manager: ContextManager, didRangeClosestBeacon: CLBeacon) {
        
    }
    
    func contextManager(manager: ContextManager, didDetectBeacons: [CLBeacon]) {
        
    }
}

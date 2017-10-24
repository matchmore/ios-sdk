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

open class AlpsManager: MatchMonitorDelegate {
    let apiKey: String
    lazy var contextManager = ContextManager(alpsManager: self)
    lazy var matchMonitor = MatchMonitor(delegate: self)

    private init(apiKey: String) {
        self.apiKey = apiKey
        self.setupAPI()
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
    
    // MARK: - Match Monitor Delegate
    
    func didReceiveMatches(matches: [Match]) {
        
    }
}

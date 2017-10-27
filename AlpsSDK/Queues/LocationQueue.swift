//
//  LocationQueue.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 27/10/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import Alps

/// Synchronus queue that sends gathered locations in every X seconds
final class LocationQueue {
    private var locationsToBeSend = [Location]()
    
    var sendingTimer: Timer?
    
    required init(sendingTimeInterval: TimeInterval) {
        assert(sendingTimeInterval <= 0, "Sending Time Interval has to be greater than 0")
        self.sendingTimer = Timer(timeInterval: sendingTimeInterval, target: self, selector: #selector(tryToSend), userInfo: nil, repeats: true)
        self.sendingTimer?.fire()
    }
    
    func sendLocations(locations: [Location]) {
        self.locationsToBeSend.append(contentsOf: locations)
    }
    
    @objc private func tryToSend() {
        if locationsToBeSend.count <= 0 { return }
        let sendingLocations = locationsToBeSend
        sendingLocations.forEach { location in
            // API should allow sending array of locations
            LocationAPI.createLocation(deviceId: "", location: location, completion: { (_, error) in
                if error != nil {
                    self.locationsToBeSend = self.locationsToBeSend.filter { $0 !== location }
                }
            })
        }
    }
}

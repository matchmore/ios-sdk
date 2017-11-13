//
//  MatchMonitor.swift
//  Alps
//
//  Created by Rafal Kowalski on 28/02/2017
//  Copyright © 2017 Alps. All rights reserved.
//

import Alps
import Foundation

protocol MatchMonitorDelegate: class {
    func didFind(matches: [Match], for device: Device)
}

public class MatchMonitor: RemoteNotificationManagerDelegate {
    
    private(set) weak var delegate: MatchMonitorDelegate?
    private(set) var monitoredDevices = Set<Device>()
    private(set) var deliveredMatches = Set<Match>()
    
    private var timer: Timer?

    init(delegate: MatchMonitorDelegate) {
        self.delegate = delegate
        self.startPollingTimer()
    }
    
    // MARK: - Match Monitoring
    public func startMonitoringFor(device: Device) {
        monitoredDevices.insert(device)
    }
    
    public func stopMonitoringFor(device: Device) {
        monitoredDevices.remove(device)
    }
    
    private func startPollingTimer() {
        if timer != nil { return }
        Timer.scheduledTimer(timeInterval: 5,
                             target: self,
                             selector: #selector(getMatches),
                             userInfo: nil,
                             repeats: true)
    }
    
    @objc private func getMatches() {
        self.monitoredDevices.forEach {
            getMatchesForDevice(device: $0)
        }
    }
    
    private func getMatchesForDevice(device: Device) {
        guard let deviceId = device.id else { return }
        MatchesAPI.getMatches(deviceId: deviceId) { (matches, error) in
            guard let matches = matches, matches.count > 0, error == nil else { return }
            let union = self.deliveredMatches.union(Set(matches))
            if union != self.deliveredMatches {
                self.deliveredMatches = union
                self.delegate?.didFind(matches: matches, for: device)
            }
        }
    }
    
    // When MatchMonitor receive a notification (push or ws) it will get the matches for the monitored devices.
    internal func remoteNotificationManager(manager: RemoteNotificationManager, didReceiveNotification: String) {
        monitoredDevices.forEach {
            if $0.id == didReceiveNotification {
                getMatchesForDevice(device: $0)
            }
        }
    }
}

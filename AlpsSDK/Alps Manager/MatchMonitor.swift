//
//  MatchMonitor.swift
//  Alps
//
//  Created by Rafal Kowalski on 28/02/2017
//  Copyright © 2017 Alps. All rights reserved.
//

import Alps
import Foundation
import Starscream

protocol MatchMonitorDelegate: class {
    func didFind(matches: [Match], for device: Device)
}

public class MatchMonitor: RemoteNotificationManagerDelegate {
    
    private(set) weak var delegate: MatchMonitorDelegate?
    private(set) var monitoredDevices = Set<Device>()
    private(set) var deliveredMatches = Set<Match>()
    
    private var timer: Timer?
    private var socket: WebSocket?

    init(delegate: MatchMonitorDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Device Monitoring
    
    func startMonitoringFor(device: Device) {
        monitoredDevices.insert(device)
    }
    
    func stopMonitoringFor(device: Device) {
        monitoredDevices.remove(device)
    }
    
    // MARK: - Polling
    
    public func startPollingMatches() {
        if timer != nil { return }
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            self.getMatches()
        }
    }
    
    public func stopPollingMatches() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Socket
    
    public func openSocketForMatches() {
        if socket != nil { return }
        guard let deviceId = monitoredDevices.first?.id else { return }
        
        var request = URLRequest(url: URL(string: "ws://\(MatchMore.baseUrl)/pusher/v5/ws/\(deviceId)")!)
        request.timeoutInterval = -1
        request.setValue("api-key, \(MatchMore.worldId)", forHTTPHeaderField: "Sec-WebSocket-Protocol")
        socket = WebSocket(request: request)
        socket?.onText = { text in
            if text != "" { // empty string just keeps connection alive
                self.getMatches()
            }
        }
        socket?.onDisconnect = { error in
            self.closeSocketForMatches()
            self.openSocketForMatches()
        }
        socket?.connect()
    }
    
    public func closeSocketForMatches() {
        socket?.disconnect()
        socket = nil
    }
    
    // MARK: - Getting Matches
    
    private func getMatches() {
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
    
    // MARK: - Remote Notification Manager Delegate
    
    func didReceiveMatchUpdateForDeviceId(deviceId: String) {
        getMatches()
    }
}

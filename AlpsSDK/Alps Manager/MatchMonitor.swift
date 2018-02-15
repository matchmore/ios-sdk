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
        // TODO: start socket after adding new device
        monitoredDevices.insert(device)
    }
    
    func stopMonitoringFor(device: Device) {
        monitoredDevices.remove(device)
    }
    
    // MARK: - Polling
    
    let kPollingTimeInterval = 2.0
    func startPollingMatches() {
        if timer != nil { return }
        timer = Timer.scheduledTimer(timeInterval: kPollingTimeInterval, target: self, selector: #selector(getMatches), userInfo: nil, repeats: true)
    }
    
    func stopPollingMatches() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Socket
    
    func openSocketForMatches() {
        if socket != nil { return }
        guard let deviceId = monitoredDevices.first?.id else { return }
        let worldId = getWorldIdFromToken(tokenstr: MatchMore.config!.apiKey)
        var url = MatchMore.config!.serverUrl
        url = url.replacingOccurrences(of: "https://", with: "")
        url = url.replacingOccurrences(of: "http://", with: "")
        url = url.replacingOccurrences(of: "/v5", with: "")
        let request = URLRequest(url: URL(string: "ws://\(url)/pusher/v5/ws/\(deviceId)")!)
        socket = WebSocket(request: request, protocols: ["api-key", worldId])
        socket?.disableSSLCertValidation = true
        socket?.onText = { text in
            if text != "ping" && text != "" && text != "pong" { // empty string or "ping" just keeps connection alive
                self.getMatches()
            }
        }
        socket?.onDisconnect = { error in
            self.socket?.connect()
        }
        socket?.onPong = { _ in
            self.socket?.write(ping: "ping".data(using: .utf8)!)
        }
        socket?.connect()
    }
    
    func closeSocketForMatches() {
        socket?.disconnect()
        socket = nil
    }
    
    // MARK: - Getting Matches
    
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
    
    // MARK: - Remote Notification Manager Delegate
    
    func didReceiveMatchUpdateForDeviceId(deviceId: String) {
        getMatches()
    }
    
    // MARK: - Helper
    
    func getWorldIdFromToken(tokenstr: String) -> String {
        var segments = tokenstr.components(separatedBy: ".")
        var base64String = segments[1]
        let requiredLength = Int(4 * ceil(Float(base64String.count) / 4.0))
        let nbrPaddings = requiredLength - base64String.count
        if nbrPaddings > 0 {
            let padding = String().padding(toLength: nbrPaddings, withPad: "=", startingAt: 0)
            base64String = base64String.appending(padding)
        }
        base64String = base64String.replacingOccurrences(of: "-", with: "+")
        base64String = base64String.replacingOccurrences(of: "_", with: "/")
        let decodedData = Data(base64Encoded: base64String, options: Data.Base64DecodingOptions(rawValue: UInt(0)))!
        let json = try? JSONSerialization.jsonObject(with: decodedData, options: .mutableContainers) as? [String: Any]
        let worldId = json!!["sub"] as? String
        return worldId!
    }
}

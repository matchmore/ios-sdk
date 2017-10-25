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
    func matchMonitor(monitor: MatchMonitor, didReceiveMatches: [Match])
}

class MatchMonitor {
    private(set) weak var delegate: MatchMonitorDelegate?
    private(set) var deliveredMatches = Set<Match>()
    
    fileprivate var timer: Timer?

    init(delegate: MatchMonitorDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Match Monitoring
    public func startMonitoringMatches() {
        if timer != nil { return }
        Timer.scheduledTimer(timeInterval: 1,
                             target: self,
                             selector: #selector(getMatches),
                             userInfo: nil,
                             repeats: true)
    }
    
    @objc func getMatches() {
        // get matches first
        delegate?.matchMonitor(monitor: self, didReceiveMatches: [])
    }

    func stopMonitoringMatches() {
        self.timer?.invalidate()
    }
}

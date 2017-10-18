//
//  MatchMonitor.swift
//  Alps
//
//  Created by Rafal Kowalski on 28/02/2017
//  Copyright © 2017 Alps. All rights reserved.
//

import Alps
import Foundation

class MatchMonitor {
    var deliveredMatches = Set<Match>()
    var onMatch: (_ match: Match) -> Void
    
    fileprivate weak var alpsManager: AlpsManager?
    fileprivate var timer: Timer?

    convenience init(alpsManager: AlpsManager) {
        self.init(alpsManager: alpsManager, onMatch: { (_ match: Match) in
            NSLog("Got a match: \(match)")
        })
    }

    init(alpsManager: AlpsManager, onMatch: @escaping ((_ match: Match) -> Void)) {
        self.alpsManager = alpsManager
        self.onMatch = onMatch
    }
    
    // MARK: - Match Monitoring
    public func startMonitoringMatches() {
        if timer != nil { return }
        timer = Timer.scheduledTimer(
                timeInterval: 1.0,
                target: self,
                selector: #selector(MatchMonitor.checkMatches),
                userInfo: nil,
                repeats: true
        )
    }

    public func stopMonitoringMatches() {
        self.timer?.invalidate()
    }

    @objc func checkMatches() {
        NSLog("checking matches")
        alpsManager?.getAllMatches { (_ matches: Matches) in
            NSLog("got all matches from the cloud: \(matches)")
            matches.forEach {
                self.deliveredMatches.insert($0)
            }
        }
    }

}

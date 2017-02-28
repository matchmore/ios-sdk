//
//  MatchMonitor.swift
//  Scalps
//
//  Created by Rafal Kowalski on 28/02/2017
//  Copyright © 2017 Scalps. All rights reserved.
//

import Scalps

import Foundation

class MatchMonitor {
    let scalpsManager: ScalpsManager
    var timer: Timer = Timer()
    var onMatch: ((_ match: Match?) -> Void)

    convenience init(scalpsManager: ScalpsManager) {
        self.init(scalpsManager: scalpsManager, onMatch: { (_ match: Match?) in print("Got a match: \(match)") })
    }

    init(scalpsManager: ScalpsManager, onMatch: @escaping ((_ match: Match?) -> Void)) {
        self.scalpsManager = scalpsManager
        self.onMatch = onMatch
    }

    public func onMatch(completion: @escaping (_ match: Match?) -> Void) {
        onMatch = completion
    }

    public func startMonitoringMatches() {
        self.timer = Timer.scheduledTimer(
          timeInterval: 1.0,
          target: self,
          selector: #selector(MatchMonitor.checkMatches),
          userInfo: nil,
          repeats: true)
    }

    public func stopMonitoringMatches() {
        self.timer.invalidate()
    }

    @objc func checkMatches() {
        scalpsManager.getAllMatches {
            (_ matches: Matches) in

            print("got matches: \(matches)")
            for m in matches {
                print("deliver this match: \(m)")
            }
        }
    }

}

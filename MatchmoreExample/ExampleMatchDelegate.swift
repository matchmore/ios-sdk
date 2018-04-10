//
//  ExampleMatchDelegate.swift
//  MatchmoreExample
//
//  Created by Maciej Burda on 21/02/2018.
//  Copyright © 2018 Matchmore. All rights reserved.
//

import Foundation
import Matchmore

class ExampleMatchHandler: MatchDelegate {
    var onMatch: OnMatchClosure?
    init(_ onMatch: @escaping OnMatchClosure) {
        self.onMatch = onMatch
    }
}

//
//  MatchDelegate.swift
//  AlpsExample
//
//  Created by Maciej Burda on 07/11/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import AlpsSDK

class MatchDelegate: AlpsManagerDelegate {
    var onMatch: OnMatchClojure
    init(_ onMatch: @escaping OnMatchClojure) {
        self.onMatch = onMatch
    }
}

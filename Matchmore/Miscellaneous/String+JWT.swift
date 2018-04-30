//
//  String+JWT.swift
//  Matchmore
//
//  Created by Maciej Burda on 21/02/2018.
//  Copyright © 2018 Matchmore. All rights reserved.
//

import Foundation

extension String {
    func getWorldIdFromToken() -> String {
        var segments: [String] = components(separatedBy: ".")
        if segments.count < 2 { return "" }
        var base64String: String = segments[1]
        let requiredLength: Int = Int(4 * ceil(Float(base64String.count) / 4.0))
        let nbrPaddings: Int = requiredLength - base64String.count
        if nbrPaddings > 0 {
            let padding = String().padding(toLength: nbrPaddings, withPad: "=", startingAt: 0)
            base64String = base64String.appending(padding)
        }
        base64String = base64String.replacingOccurrences(of: "-", with: "+")
        base64String = base64String.replacingOccurrences(of: "_", with: "/")
        let decodedData: Data = Data(base64Encoded: base64String, options: Data.Base64DecodingOptions(rawValue: UInt(0)))!
        if let json = try? JSONSerialization.jsonObject(with: decodedData, options: .mutableContainers) as? [String: Any],
            let worldId: String = json?["sub"] as? String {
            return worldId
        } else {
            return ""
        }
    }
}

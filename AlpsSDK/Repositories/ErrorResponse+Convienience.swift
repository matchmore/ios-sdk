//
//  ErrorResponse+Convienience.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 14/11/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import Alps

public extension ErrorResponse {
    public var message: String? {
        guard case let .Error(_, data, _) = self, data != nil else { return nil }
        return String(data: data!, encoding: String.Encoding.utf8)
    }
    
    static var missingId: ErrorResponse {
        let info = "missing id"
        let code = 10408
        return errorWith(info: info, code: code)
    }
    
    public static func errorWith(info: String, code: Int) -> ErrorResponse {
        return .Error(code, info.data(using: .utf8), NSError(domain: "io.matchmore.ios.sdk", code: code, userInfo: ["reason": info]))
    }
}

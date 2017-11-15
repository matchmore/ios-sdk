//
//  Result.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 14/11/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import Alps

public enum Result<T> {
    case success(T)
    case failure(ErrorResponse?)
    
    var responseObject: T? {
        guard case let .success(responseObject) = self else { return nil }
        return responseObject
    }
    var errorMesseage: String? {
        guard case let .failure(error) = self else { return nil }
        return error?.message
    }
}

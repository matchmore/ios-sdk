//
//  PDevice.swift
//  AlpsSDK
//
//  Created by Wen on 04.08.17.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation

protocol PDevice {
    var deviceId : String? { get }
    var name : String? { get set }
}

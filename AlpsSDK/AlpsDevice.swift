//
//  AlpsDevice.swift
//  Alps
//
//  Created by Rafal Kowalski on 21/12/2016
//  Copyright © 2016 Alps. All rights reserved.
//

import Foundation
import Alps
import SwiftyBeaver

open class AlpsDevice {
    public let manager: AlpsManager
    public let device: Device

    public init(manager: AlpsManager, device: Device) {
        self.manager = manager
        self.device = device
    }

    public func id() -> String {
        return device.id!
    }

    public func createPublication(_ publication: Publication, completion: @escaping (_ publication: Publication?) -> Void) {
        SwiftyBeaver.info("Not implemented yet.")
    }
}

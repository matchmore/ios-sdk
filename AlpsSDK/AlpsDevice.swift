//
//  AlpsDevice.swift
//  Alps
//
//  Created by Rafal Kowalski on 21/12/2016
//  Copyright © 2016 Alps. All rights reserved.
//

import Foundation
import Alps

open class AlpsDevice {
    public let manager: AlpsManager
    public let user: User
    public let device: Device

    public init(manager: AlpsManager, user: User, device: Device) {
        self.manager = manager
        self.user = user
        self.device = device
    }

    public func id() -> String {
        return device.id!
    }

    public func createPublication(_ publication: Publication, completion: @escaping (_ publication: Publication?) -> Void) {
        print("Not implemented yet.")
    }
}

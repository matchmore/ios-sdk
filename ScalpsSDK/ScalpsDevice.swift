//
//  ScalpsDevice.swift
//  Scalps
//
//  Created by Rafal Kowalski on 21/12/2016
//  Copyright © 2016 Scalps. All rights reserved.
//

import Foundation
import Scalps

open class ScalpsDevice {
    public let manager: ScalpsManager
    public let user: User
    public let device: Device

    public init(manager: ScalpsManager, user: User, device: Device) {
        self.manager = manager
        self.user = user
        self.device = device
    }

    public func id() -> String {
        return device.deviceId!
    }

    public func createPublication(_ publication: Publication, completion: @escaping (_ publication: Publication?) -> Void) {
        /*
        let userCompletion = completion
        let publicationTemplate = publication


        let _ = manager.createPublication(publicationTemplate, for: user, on: device) {
            (_ publication) in
            userCompletion(publication)
        }
         */
    }
}

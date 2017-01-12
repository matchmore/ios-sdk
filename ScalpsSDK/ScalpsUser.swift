//
//  ScalpsUser.swift
//  Scalps
//
//  Created by Rafal Kowalski on 21/12/2016
//  Copyright © 2016 Scalps. All rights reserved.
//

import Foundation
import Scalps

open class ScalpsUser {
    public let manager: ScalpsManager
    public let user: User

    public init(manager: ScalpsManager, user: User) {
        self.manager = manager
        self.user = user
    }

    public func id() -> String {
        return user.userId!
    }
}

//
//  RemoteNotificationManager.swift
//  AlpsSDK
//
//  Created by Wen on 07.11.17.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation

protocol RemoteNotificationManagerDelegate: class {
    func didReceiveMatchUpdateForDeviceId(deviceId: String)
}

public class RemoteNotificationManager: NSObject {
    
    private weak var delegate: RemoteNotificationManagerDelegate?
    private var deviceToken: String!
    
    init(delegate: RemoteNotificationManagerDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    func registerDeviceToken(deviceToken: String) {
        self.deviceToken = deviceToken
    }
    
    func consume(pushNotification: [AnyHashable: Any]) {
        guard pushNotification["matchId"] != nil else { return }
        delegate?.didReceiveMatchUpdateForDeviceId(deviceId: "")
    }
}

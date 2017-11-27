//
//  SubscriptionRepository.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 27/10/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import Alps

let kSubscriptionFile = "kSubscriptionFile.Alps"

final public class SubscriptionStore: CRD {
    typealias DataType = Subscription
    
    internal private(set) var items: [Subscription] {
        get {
            return _items.withoutExpired
        }
        set {
            _items = newValue
        }
    }
    
    private var _items = [Subscription]() {
        didSet {
            _ = PersistenceManager.save(object: self._items.withoutExpired.map { $0.encodableSubscription }, to: kSubscriptionFile)
        }
    }
    
    internal init() {
        self.items = PersistenceManager.read(type: [EncodableSubscription].self, from: kSubscriptionFile)?.map { $0.object }.withoutExpired ?? []
    }
    
    public func create(item: Subscription, completion: @escaping (Result<Subscription>) -> Void) {
        guard let deviceId = item.deviceId else { return }
        SubscriptionAPI.createSubscription(deviceId: deviceId, subscription: item) { (subscription, error) in
            if let subscription = subscription, error == nil {
                self.items.append(subscription)
                completion(.success(subscription))
            } else {
                completion(.failure(error as? ErrorResponse))
            }
        }
    }
    
    public func find(byId: String, completion: @escaping (Result<Subscription>) -> Void) {
        let item = items.filter { $0.id ?? "" == byId }.first
        if let item = item {
            completion(.success(item))
        } else {
            completion(.failure(ErrorResponse.itemNotFound))
        }
    }
    
    public func findAll(completion: @escaping (Result<[Subscription]>) -> Void) {
        completion(.success(items))
    }
    
    public func delete(item: Subscription, completion: @escaping (ErrorResponse?) -> Void) {
        guard let id = item.id else { completion(ErrorResponse.missingId); return }
        guard let deviceId = item.deviceId else { completion(ErrorResponse.missingId); return }
        SubscriptionAPI.deleteSubscription(deviceId: deviceId, subscriptionId: id, completion: { (error) in
            if error == nil {
                self.items = self.items.filter { $0.id != id }
            }
            completion(error as? ErrorResponse)
        })
    }
}

extension SubscriptionStore: DeviceDeleteDelegate {
    func didDeleteDeviceWith(id: String) {
        self.items = self.items.filter { $0.deviceId != id }
    }
}

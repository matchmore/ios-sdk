//
//  SubscriptionRepository.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 27/10/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import Alps

final class SubscriptionRepository: DataRepostiory, AsyncCreateable, AsyncReadable, AsyncDeleteable {
    typealias DataType = Subscription
    var items = [Subscription]()
    
    func create(item: Subscription, completion: @escaping (Result<Subscription?>) -> Void) {
        guard let deviceId = item.deviceId else { return }
        SubscriptionAPI.createSubscription(deviceId: deviceId, subscription: item) { (subscription, error) in
            if let subscription = subscription, error == nil {
                self.items.append(subscription)
                completion(.success(subscription))
            } else {
                completion(.failure(error))
            }
        }
    }
    
    func find(byId: String, completion: @escaping (Result<Subscription?>) -> Void) {
        completion(.success(items.filter { $0.id == byId }.first))
    }
    
    func findAll(completion: @escaping (Result<[Subscription]>) -> Void) {
        completion(.success(items))
    }
    
    func delete(item: Subscription, completion: @escaping (Error?) -> Void) {
        guard let id = item.id else { completion(nil); return }
        guard let deviceId = item.deviceId else { completion(nil); return }
        SubscriptionAPI.deleteSubscription(deviceId: deviceId, subscriptionId: id, completion: { (error) in
            self.items = self.items.filter { $0 !== item }
            completion(error)
        })
    }
}

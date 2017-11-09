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

final public class SubscriptionRepository: AsyncCreateable, AsyncReadable, AsyncDeleteable {
    typealias DataType = Subscription
    
    private(set) var items = [Subscription]() {
        didSet {
            _ = PersistenceManager.save(object: self.items.map { $0.encodableSubscription }, to: kSubscriptionFile)
        }
    }
    
    init() {
        self.items = PersistenceManager.read(type: [EncodableSubscription].self, from: kSubscriptionFile)?.map { $0.object } ?? []
    }
    
    func create(item: Subscription, completion: @escaping (Result<Subscription?>) -> Void) {
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
    
    func find(byId: String, completion: @escaping (Result<Subscription?>) -> Void) {
        completion(.success(items.filter { $0.id == byId }.first))
    }
    
    func findAll(completion: @escaping (Result<[Subscription]>) -> Void) {
        completion(.success(items))
    }
    
    func delete(item: Subscription, completion: @escaping (ErrorResponse?) -> Void) {
        guard let id = item.id else { completion(ErrorResponse.missingId); return }
        guard let deviceId = item.deviceId else { completion(ErrorResponse.missingId); return }
        self.items = self.items.filter { $0 !== item }
        SubscriptionAPI.deleteSubscription(deviceId: deviceId, subscriptionId: id, completion: { (error) in
            completion(error as? ErrorResponse)
        })
    }
    
    func deleteAll() {
        items.forEach { self.delete(item: $0, completion: { (_) in }) }
        items = []
    }
}

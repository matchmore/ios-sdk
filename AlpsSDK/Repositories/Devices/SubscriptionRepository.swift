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
        
    }
    
    func find(byId: String, completion: @escaping (Result<Subscription?>) -> Void) {
        
    }
    
    func findAll(completion: @escaping (Result<[Subscription]>) -> Void) {
        
    }
    
    func delete(item: Subscription, completion: @escaping (Error?) -> Void) {
        
    }
}

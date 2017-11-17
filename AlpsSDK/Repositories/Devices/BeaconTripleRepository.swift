//
//  BeaconRepository.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 25/10/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import Alps

let kBeaconFile = "kBeaconFile.Alps"

final public class BeaconTripleRepository: AsyncReadable {
    
    typealias DataType = IBeaconTriple
    internal private(set) var items = [IBeaconTriple]() {
        didSet {
            _ = PersistenceManager.save(object: self.items.map { $0.encodableIBeaconTriple }, to: kBeaconFile)
        }
    }
    
    internal init() {
        self.items = PersistenceManager.read(type: [EncodableIBeaconTriple].self, from: kBeaconFile)?.map { $0.object } ?? []
    }
    
    public func find(byId: String, completion: @escaping (Result<IBeaconTriple>) -> Void) {
        let item = items.filter { $0.deviceId ?? "" == byId }.first
        if let item = item {
            completion(.success(item))
        } else {
            completion(.failure(ErrorResponse.itemNotFound))
        }
    }
    
    public func findAll(completion: @escaping (Result<[IBeaconTriple]>) -> Void) {
        completion(.success(items))
    }
    
    public func updateBeaconTriplets(completion: (() -> Void)? = nil) {
        DeviceAPI.getIBeaconTriples { [weak self] (beaconTriplets, error) in
            if let beaconTriplets = beaconTriplets, error == nil {
                self?.items = beaconTriplets
            }
            completion?()
        }
    }
}

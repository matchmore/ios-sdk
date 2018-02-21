//
//  BeaconStore.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 25/10/2017.
//  Copyright © 2018 Matchmore SA. All rights reserved.
//

import Foundation
import Alps

let kBeaconFile = "kBeaconFile.Alps"

final public class BeaconTripleStore: AsyncReadable {
    
    typealias DataType = IBeaconTriple
    internal private(set) var items = [IBeaconTriple]() {
        didSet {
            _ = PersistenceManager.save(object: self.items.map { $0.encodableIBeaconTriple }, to: kBeaconFile)
        }
    }
    
    internal init() {
        self.items = PersistenceManager.read(type: [EncodableIBeaconTriple].self, from: kBeaconFile)?.map { $0.object } ?? []
    }
    
    public func find(byId: String, completion: @escaping (IBeaconTriple?) -> Void) {
        completion(items.filter { $0.deviceId ?? "" == byId }.first)
    }
    
    public func findAll(completion: @escaping ([IBeaconTriple]) -> Void) {
        completion(items)
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

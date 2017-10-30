//
//  BeaconRepository.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 25/10/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import Alps

final class BeaconRepository: AsyncReadable {
    typealias DataType = IBeaconTriple
    private var items = [IBeaconTriple]()
    
    init() {
        updateBeaconTriplets()
    }
    
    func find(byId: String, completion: @escaping (Result<IBeaconTriple?>) -> Void) {
        completion(.success(items.filter { $0.deviceId == byId }.first))
        updateBeaconTriplets {
            completion(.success(self.items.filter { $0.deviceId == byId }.first))
        }
    }
    
    func findAll(completion: @escaping (Result<[IBeaconTriple]>) -> Void) {
        completion(.success(items))
        updateBeaconTriplets {
            completion(.success(self.items))
        }
    }
    
    private func updateBeaconTriplets(completion: (() -> Void)? = nil) {
        Alps.DeviceAPI.getIBeaconTriples { [weak self] (beaconTriplets, error) in
            if let beaconTriplets = beaconTriplets, error == nil {
                self?.items = beaconTriplets
            }
            completion?()
        }
    }
}

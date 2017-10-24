//
//  DeviceRepository.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 24/10/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import Alps

final class DeviceRepository: DataRepostiory, C, R, D {
    typealias DataType = Device
    private(set) var items = [Device]()
    
    func create(item: Device, completion: @escaping (Result<Device?>) -> Void) {
        DeviceAPI.createDevice(device: item) { (device, error) -> Void in
            if let device = device, error == nil {
                self.items.append(device)
                completion(.success(device))
            } else {
                completion(.failure(error))
            }
        }
    }
    
    func find(byId: String, completion: @escaping (Result<Device?>) -> Void) {
        completion(.success(items.filter { $0.id == byId }.first))
    }
    
    func findAll(completion: @escaping (Result<[Device]>) -> Void) {
        completion(.success(items))
    }
    
    func delete(item: Device, completion: @escaping (Error?) -> Void) {
        guard let id = item.id else { completion(nil); return }
        Alps.DeviceAPI.deleteDevice(deviceId: id) { (error) in
            completion(error)
        }
    }
}

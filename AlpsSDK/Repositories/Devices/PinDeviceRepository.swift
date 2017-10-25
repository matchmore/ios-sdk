//
//  PinDeviceRepository.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 20/10/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import Alps

final class PinDeviceRepository: DataRepostiory, AsyncCreateable, AsyncReadable, AsyncDeleteable {
    typealias DataType = PinDevice
    private(set) var items = [PinDevice]()
    
    func create(item: PinDevice, completion: @escaping (Result<PinDevice?>) -> Void) {
        DeviceAPI.createDevice(device: item) { (device, error) -> Void in
            if let pinDevice = device as? PinDevice, error == nil {
                self.items.append(pinDevice)
                completion(.success(pinDevice))
            } else {
                completion(.failure(error))
            }
        }
    }
    
    func find(byId: String, completion: @escaping (Result<PinDevice?>) -> Void) {
        completion(.success(items.filter { $0.id == byId }.first))
    }
    
    func findAll(completion: @escaping (Result<[PinDevice]>) -> Void) {
        completion(.success(items))
    }
    
    func delete(item: PinDevice, completion: @escaping (Error?) -> Void) {
        guard let id = item.id else { completion(nil); return }
        Alps.DeviceAPI.deleteDevice(deviceId: id) { (error) in
            self.items = self.items.filter { $0 !== item }
            completion(error)
        }
    }
}

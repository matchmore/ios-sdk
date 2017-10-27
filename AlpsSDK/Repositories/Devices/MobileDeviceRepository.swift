//
//  MobileDeviceRepository.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 27/10/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation

import Foundation
import Alps

final class MobileDeviceRepository: DataRepostiory, AsyncCreateable, AsyncReadable, AsyncDeleteable {
    typealias DataType = MobileDevice
    private(set) var items = [MobileDevice]()
    
    func create(item: MobileDevice, completion: @escaping (Result<MobileDevice?>) -> Void) {
        DeviceAPI.createDevice(device: item) { (device, error) -> Void in
            if let device = device as? MobileDevice, error == nil {
                self.items.append(device)
                completion(.success(device))
            } else {
                completion(.failure(error))
            }
        }
    }
    
    func find(byId: String, completion: @escaping (Result<MobileDevice?>) -> Void) {
        completion(.success(items.filter { $0.id == byId }.first))
    }
    
    func findAll(completion: @escaping (Result<[MobileDevice]>) -> Void) {
        completion(.success(items))
    }
    
    func delete(item: MobileDevice, completion: @escaping (Error?) -> Void) {
        guard let id = item.id else { completion(nil); return }
        Alps.DeviceAPI.deleteDevice(deviceId: id) { (error) in
            self.items = self.items.filter { $0 !== item }
            completion(error)
        }
    }
}

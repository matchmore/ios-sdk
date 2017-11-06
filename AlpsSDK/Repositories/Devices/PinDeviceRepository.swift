//
//  PinDeviceRepository.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 20/10/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import Alps

let kPinDevicesFile = "kPinDevicesFile.Alps"

final class PinDeviceRepository: AsyncCreateable, AsyncReadable, AsyncDeleteable {
    typealias DataType = PinDevice
    
    private(set) var items = [PinDevice]() {
        didSet {
            _ = PersistenceManager.save(object: self.items.map { $0.encodablePinDevice }, to: kPinDevicesFile)
        }
    }
    
    init() {
        self.items = PersistenceManager.read(type: [EncodablePinDevice].self, from: kPinDevicesFile)?.map { $0.object } ?? []
    }
    
    func create(item: PinDevice, completion: @escaping (Result<PinDevice?>) -> Void) {
        DeviceAPI.createDevice(device: item) { (device, error) -> Void in
            if let pinDevice = device as? PinDevice, error == nil {
                self.items.append(pinDevice)
                completion(.success(pinDevice))
            } else {
                completion(.failure(error as? ErrorResponse))
            }
        }
    }
    
    func find(byId: String, completion: @escaping (Result<PinDevice?>) -> Void) {
        completion(.success(items.filter { $0.id == byId }.first))
    }
    
    func findAll(completion: @escaping (Result<[PinDevice]>) -> Void) {
        completion(.success(items))
    }
    
    func delete(item: PinDevice, completion: @escaping (ErrorResponse?) -> Void) {
        guard let id = item.id else { completion(nil); return }
        DeviceAPI.deleteDevice(deviceId: id) { (error) in
            self.items = self.items.filter { $0 !== item }
            completion(error as? ErrorResponse)
        }
    }
}

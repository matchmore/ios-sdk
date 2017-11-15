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

final public class PinDeviceRepository: CRD {
    typealias DataType = PinDevice
    
    internal private(set) var delegates = MulticastDelegate<DeviceDeleteDelegate>()
    
    internal private(set) var items = [PinDevice]() {
        didSet {
            _ = PersistenceManager.save(object: self.items.map { $0.encodablePinDevice }, to: kPinDevicesFile)
        }
    }
    
    internal init() {
        self.items = PersistenceManager.read(type: [EncodablePinDevice].self, from: kPinDevicesFile)?.map { $0.object } ?? []
    }
    
    public func create(item: PinDevice, completion: @escaping (Result<PinDevice>) -> Void) {
        DeviceAPI.createDevice(device: item) { (device, error) -> Void in
            if let pinDevice = device as? PinDevice, error == nil {
                self.items.append(pinDevice)
                completion(.success(pinDevice))
            } else {
                completion(.failure(error as? ErrorResponse))
            }
        }
    }
    
    public func find(byId: String, completion: @escaping (Result<PinDevice>) -> Void) {
        let item = items.filter { $0.id ?? "" == byId }.first
        if let item = item {
            completion(.success(item))
        } else {
            completion(.failure(ErrorResponse.itemNotFound))
        }
    }
    
    public func findAll(completion: @escaping (Result<[PinDevice]>) -> Void) {
        completion(.success(items))
    }
    
    public func delete(item: PinDevice, completion: @escaping (ErrorResponse?) -> Void) {
        guard let id = item.id else { completion(ErrorResponse.missingId); return }
        DeviceAPI.deleteDevice(deviceId: id) { (error) in
            if error == nil {
                self.items = self.items.filter { $0.id != id }
                self.delegates.invoke { $0.didDeleteDeviceWith(id: id) }
            }
            completion(error as? ErrorResponse)
        }
    }
}

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

let kMainDeviceFile = "kMainDeviceFile.Alps"
let kMobileDevicesFile = "kMobileDevicesFile.Alps"

final public class MobileDeviceRepository: AsyncCreateable, AsyncReadable, AsyncDeleteable {
    typealias DataType = MobileDevice
    
    private(set) var items = [MobileDevice]() {
        didSet {
            _ = PersistenceManager.save(object: self.items.map { $0.encodableMobileDevice }, to: kMobileDevicesFile)
        }
    }
    public var main: MobileDevice? {
        didSet {
            _ = PersistenceManager.save(object: self.main?.encodableMobileDevice, to: kMainDeviceFile)
        }
    }
    
    init() {
        self.main = PersistenceManager.read(type: EncodableMobileDevice.self, from: kMainDeviceFile)?.object
        self.items = PersistenceManager.read(type: [EncodableMobileDevice].self, from: kMobileDevicesFile)?.map { $0.object } ?? []
    }
    
    func create(item: MobileDevice, completion: @escaping (Result<MobileDevice?>) -> Void) {
        DeviceAPI.createDevice(device: item) { (device, error) -> Void in
            if let device = device as? MobileDevice, error == nil {
                self.items.append(device)
                if self.main == nil { self.main = device }
                completion(.success(device))
            } else {
                completion(.failure(error as? ErrorResponse))
            }
        }
    }
    
    func find(byId: String, completion: @escaping (Result<MobileDevice?>) -> Void) {
        completion(.success(items.filter { $0.id == byId }.first))
    }
    
    func findAll(completion: @escaping (Result<[MobileDevice]>) -> Void) {
        completion(.success(items))
    }
    
    // TODO: It requires OK from backend (maybe queue?)
    func delete(item: MobileDevice, completion: @escaping (ErrorResponse?) -> Void) {
        guard let id = item.id else { completion(ErrorResponse.missingId); return }
        if self.main?.id == id { self.main = nil }
        self.items = self.items.filter { $0 !== item }
        DeviceAPI.deleteDevice(deviceId: id) { (error) in
            completion(error as? ErrorResponse)
        }
    }
    
    func deleteAll() {
        items.forEach { self.delete(item: $0, completion: { (_) in }) }
        items = []
        main = nil
    }
}

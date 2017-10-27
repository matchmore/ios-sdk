//
//  DataRepostiory.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 19/10/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation

/// Together with protocols below defines full CRUD interface for model
protocol DataRepostiory: AssociatedDataType {
    var items: [DataType] { get }
}

protocol AsyncCreateable: AssociatedDataType {
    func create(item: DataType, completion: @escaping (Result<DataType?>) -> Void)
}

protocol AsyncReadable: AssociatedDataType {
    func find(byId: String, completion: @escaping (Result<DataType?>) -> Void)
    func findAll(completion: @escaping (Result<[DataType]>) -> Void)
}

protocol AsyncUpdateable: AssociatedDataType {
    func update(item: DataType, completion: @escaping (Result<DataType?>) -> Void)
}

protocol AsyncDeleteable: AssociatedDataType {
    func delete(item: DataType, completion: @escaping (Error?) -> Void)
}

// MARK: - Helper protocols

enum Result<T> {
    case success(T)
    case failure(Error?)
}

protocol AssociatedDataType {
    associatedtype DataType
}

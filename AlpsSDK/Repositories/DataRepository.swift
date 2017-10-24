//
//  AsyncRepository.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 19/10/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error?)
}

protocol AssociatedDataType {
    associatedtype DataType
}

protocol DataRepostiory: AssociatedDataType {
    var items: [DataType] { get }
}

typealias C = AsyncCreateable
protocol AsyncCreateable: AssociatedDataType {
    func create(item: DataType, completion: @escaping (Result<DataType?>) -> Void)
}

typealias R = AsyncReadable
protocol AsyncReadable: AssociatedDataType {
    func find(byId: String, completion: @escaping (Result<DataType?>) -> Void)
    func findAll(completion: @escaping (Result<[DataType]>) -> Void)
}

typealias U = AsyncUpdateable
protocol AsyncUpdateable: AssociatedDataType {
    func update(item: DataType, completion: @escaping (Result<DataType?>) -> Void)
}

typealias D = AsyncDeleteable
protocol AsyncDeleteable: AssociatedDataType {
    func delete(item: DataType, completion: @escaping (Error?) -> Void)
}

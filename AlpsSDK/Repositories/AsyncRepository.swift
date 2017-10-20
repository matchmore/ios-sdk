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

protocol AsyncRepostiory: AsyncCreateable, AsyncReadable, AsyncDeleteable {
    var items: [DataType] { get }
}

protocol AssociatedDataType {
    associatedtype DataType
}

protocol AsyncCreateable: AssociatedDataType {
    func create(item: DataType, completion: @escaping (Result<DataType?>) -> Void)
}

protocol AsyncReadable: AssociatedDataType {
    func find(byId: String, completion: @escaping (Result<DataType?>) -> Void)
    func findAll(completion: @escaping (Result<[DataType]>) -> Void)
}

protocol AsyncDeleteable: AssociatedDataType {
    func delete(item: DataType, completion: @escaping (Error?) -> Void)
}

//
//  DataRepostiory.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 19/10/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import Alps

/// Together with all protocols below defines full CRUD interface for data type model

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
    func delete(item: DataType, completion: @escaping (ErrorResponse?) -> Void)
}

// MARK: - Helper protocols

enum Result<T> {
    case success(T)
    case failure(ErrorResponse?)
}

protocol AssociatedDataType {
    associatedtype DataType
}

extension ErrorResponse {
    var description: String? {
        guard case let .Error(_, data, _) = self, data != nil else { return nil }
        return String(data: data!, encoding: String.Encoding.utf8)
    }
}

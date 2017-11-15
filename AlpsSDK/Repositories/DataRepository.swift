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

protocol AsyncClearable: AssociatedDataType {
    func deleteAll(completion: @escaping (ErrorResponse?) -> Void)
}

// Default implementation for delete all items
extension AsyncClearable where Self: AsyncDeleteable {
    func deleteAll(completion: @escaping (ErrorResponse?) -> Void) {
        var lastError: ErrorResponse?
        let dispatchGroup = DispatchGroup()
        items.forEach {
            dispatchGroup.enter()
            self.delete(item: $0, completion: { error in
                if let error = error { lastError = error }
                dispatchGroup.leave()
            })
        }
        dispatchGroup.notify(queue: .main) {
            completion(lastError)
        }
    }
}

// MARK: - Helper protocols

public enum Result<T> {
    case success(T)
    case failure(ErrorResponse?)
    
    var responseObject: T? {
        guard case let .success(responseObject) = self else { return nil }
        return responseObject
    }
    var messeage: String? {
        guard case let .failure(error) = self else { return nil }
        return error?.message
    }
}

protocol AssociatedDataType {
    associatedtype DataType
    var items: [DataType] { get }
}

extension ErrorResponse {
    var message: String? {
        guard case let .Error(_, data, _) = self, data != nil else { return nil }
        return String(data: data!, encoding: String.Encoding.utf8)
    }
    
    static var missingId: ErrorResponse {
        let info = "missing id"
        let code = 10408
        return errorWith(info: info, code: code)
    }
    
    static func errorWith(info: String, code: Int) -> ErrorResponse {
        return .Error(code, info.data(using: .utf8), NSError(domain: "localhost", code: code, userInfo: ["reason": info]))
    }
}

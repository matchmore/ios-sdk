//
//  DataStore.swift
//  Matchmore
//
//  Created by Maciej Burda on 19/10/2017.
//  Copyright © 2018 Matchmore SA. All rights reserved.
//

/// Together with all protocols below defines full CRUD interface for data type model

protocol CRUDP: AsyncCreateable, AsyncReadable, AsyncUpdateable, AsyncDeleteable {}

typealias CRUD = AsyncCreateable & AsyncReadable & AsyncUpdateable & AsyncDeleteable & AsyncClearable
typealias CRD = AsyncCreateable & AsyncReadable & AsyncDeleteable & AsyncClearable

protocol AssociatedDataType {
    var id: String { get }
    associatedtype T
    var items: [T] { get }
}

typealias ResultClosure<T> = (Result<T>) -> Void
typealias ErrorClosure = (ErrorResponse?) -> Void
typealias ObjectClosure<T> = (T?) -> Void
typealias ArrayClosure<T> = ([T]) -> Void

protocol AsyncCreateable: AssociatedDataType {
    func create(item: T, completion: @escaping ResultClosure<T>)
}

protocol AsyncReadable: AssociatedDataType {
    func find(byId: String, completion: @escaping ObjectClosure<T>)
    func findAll(completion: @escaping ArrayClosure<T>)
}

protocol AsyncUpdateable: AssociatedDataType {
    func update(item: T, completion: @escaping ResultClosure<T>)
}

protocol AsyncDeleteable: AssociatedDataType {
    func delete(item: T, completion: @escaping ErrorClosure)
}

protocol AsyncClearable: AssociatedDataType {
    func deleteAll(completion: @escaping ErrorClosure)
}

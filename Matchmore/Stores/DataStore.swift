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
    associatedtype DataType
    var id: String { get }
    var items: [DataType] { get }
}

typealias ResultClosure<DataType> = (Result<DataType>) -> Void
typealias ErrorClosure = (ErrorResponse?) -> Void
typealias ObjectClosure<DataType> = (DataType?) -> Void
typealias ArrayClosure<DataType> = ([DataType]) -> Void

protocol AsyncCreateable: AssociatedDataType {
    func create(item: DataType, completion: @escaping ResultClosure<DataType>)
}

protocol AsyncReadable: AssociatedDataType {
    func find(byId: String, completion: @escaping ObjectClosure<DataType>)
    func findAll(completion: @escaping ArrayClosure<DataType>)
}

protocol AsyncUpdateable: AssociatedDataType {
    func update(item: DataType, completion: @escaping ResultClosure<DataType>)
}

protocol AsyncDeleteable: AssociatedDataType {
    func delete(item: DataType, completion: @escaping ErrorClosure)
}

protocol AsyncClearable: AssociatedDataType {
    func deleteAll(completion: @escaping ErrorClosure)
}

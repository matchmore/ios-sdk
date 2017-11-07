//
//  PublicationRepository.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 27/10/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import Alps

let kPublicationFile = "kPublicationFile.Alps"

final public class PublicationRepository: AsyncCreateable, AsyncReadable, AsyncDeleteable {
    typealias DataType = Publication
    
    private(set) var items = [Publication]() {
        didSet {
            _ = PersistenceManager.save(object: self.items.map { $0.encodablePublication }, to: kPublicationFile)
        }
    }
    
    init() {
        self.items = PersistenceManager.read(type: [EncodablePublication].self, from: kPublicationFile)?.map { $0.object } ?? []
    }
    
    func create(item: Publication, completion: @escaping (Result<Publication?>) -> Void) {
        guard let deviceId = item.deviceId else { return }
        PublicationAPI.createPublication(deviceId: deviceId, publication: item) { (publication, error) in
            if let publication = publication, error == nil {
                self.items.append(publication)
                completion(.success(publication))
            } else {
                completion(.failure(error as? ErrorResponse))
            }
        }
    }
    
    func find(byId: String, completion: @escaping (Result<Publication?>) -> Void) {
        completion(.success(items.filter { $0.id == byId }.first))
    }
    
    func findAll(completion: @escaping (Result<[Publication]>) -> Void) {
        completion(.success(items))
    }
    
    func delete(item: Publication, completion: @escaping (ErrorResponse?) -> Void) {
        guard let id = item.id else { completion(ErrorResponse.missingId); return }
        guard let deviceId = item.deviceId else { completion(ErrorResponse.missingId); return }
        self.items = self.items.filter { $0 !== item }
        PublicationAPI.deletePublication(deviceId: deviceId, publicationId: id, completion: { (error) in
            completion(error as? ErrorResponse)
        })
    }
    
    func deleteAll() {
        items.forEach { self.delete(item: $0, completion: { (_) in }) }
        items = []
    }
}

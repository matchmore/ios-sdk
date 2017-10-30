//
//  PublicationRepository.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 27/10/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation
import Alps

final class PublicationRepository: AsyncCreateable, AsyncReadable, AsyncDeleteable {
    typealias DataType = Publication
    private var items = [Publication]()
    
    func create(item: Publication, completion: @escaping (Result<Publication?>) -> Void) {
        guard let deviceId = item.deviceId else { return }
        PublicationAPI.createPublication(deviceId: deviceId, publication: item) { (publication, error) in
            if let publication = publication, error == nil {
                self.items.append(publication)
                completion(.success(publication))
            } else {
                completion(.failure(error))
            }
        }
    }
    
    func find(byId: String, completion: @escaping (Result<Publication?>) -> Void) {
        completion(.success(items.filter { $0.id == byId }.first))
    }
    
    func findAll(completion: @escaping (Result<[Publication]>) -> Void) {
        completion(.success(items))
    }
    
    func delete(item: Publication, completion: @escaping (Error?) -> Void) {
        guard let id = item.id else { completion(nil); return }
        guard let deviceId = item.deviceId else { completion(nil); return }
        PublicationAPI.deletePublication(deviceId: deviceId, publicationId: id, completion: { (error) in
            self.items = self.items.filter { $0 !== item }
            completion(error)
        })
    }
    
}

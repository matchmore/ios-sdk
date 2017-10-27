//
//  PublicationRepository.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 27/10/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation

import Foundation
import Alps

final class PublicationRepository: DataRepostiory, AsyncCreateable, AsyncReadable, AsyncDeleteable {
    typealias DataType = Publication
    var items = [Publication]()
    
    func create(item: Publication, completion: @escaping (Result<Publication?>) -> Void) {
        
    }
    
    func find(byId: String, completion: @escaping (Result<Publication?>) -> Void) {
        
    }
    
    func findAll(completion: @escaping (Result<[Publication]>) -> Void) {
        
    }
    
    func delete(item: Publication, completion: @escaping (Error?) -> Void) {
        
    }
    
}

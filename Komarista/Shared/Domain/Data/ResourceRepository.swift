//
//  ResourceRepository.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/27/21.
//

import Foundation
import FirebaseStorage

protocol ResourceRepository {
    typealias LoadCallback = (Result<Data, ErrorEntity>) -> Void
    func load(image id: String, _ callback: @escaping LoadCallback)
}

struct DefaultResourceRepository: ResourceRepository {
    private let storageReference: StorageReference = {
        let storage = Storage.storage()
        return storage.reference()
    }()

    func load(image id: String, _ callback: @escaping LoadCallback) {
        let reference = storageReference.child(id)
        reference.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                callback(.failure(.init(from: error)))
            } else {
                callback(.success(data!))
            }
        }
    }
}

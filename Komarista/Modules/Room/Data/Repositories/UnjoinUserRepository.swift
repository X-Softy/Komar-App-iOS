//
//  UnjoinUserRepository.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/24/21.
//

import Combine

protocol UnjoinUserRepository: APIRepository {
    func unjoin(from room: String) -> AnyPublisher<None, ErrorEntity>
}

struct DefaultUnjoinUserRepository: UnjoinUserRepository {
    func unjoin(from room: String) -> AnyPublisher<None, ErrorEntity> {
        call(with: requestBuilder
                       .set(path: "/rooms/unjoin/\(room)")
                       .set(method: HTTPMethodPatch()))
    }
}

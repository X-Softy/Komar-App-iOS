//
//  JoinUserRepository.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/24/21.
//

import Combine

protocol JoinUserRepository: APIRepository {
    func join(to room: String) -> AnyPublisher<None, ErrorEntity>
}

struct DefaultJoinUserRepository: JoinUserRepository {
    func join(to room: String) -> AnyPublisher<None, ErrorEntity> {
        call(with: requestBuilder
                       .set(path: "/rooms/join/\(room)")
                       .set(method: HTTPMethodPatch()))
    }
}

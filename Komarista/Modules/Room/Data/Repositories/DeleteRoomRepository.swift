//
//  DeleteRoomRepository.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/24/21.
//

import Combine

protocol DeleteRoomRepository: APIRepository {
    func delete(room: String) -> AnyPublisher<None, ErrorEntity>
}

struct DefaultDeleteRoomRepository: DeleteRoomRepository {
    func delete(room: String) -> AnyPublisher<None, ErrorEntity> {
        call(with: requestBuilder
                       .set(path: "/rooms/\(room)")
                       .set(method: HTTPMethodDelete()))
    }
}

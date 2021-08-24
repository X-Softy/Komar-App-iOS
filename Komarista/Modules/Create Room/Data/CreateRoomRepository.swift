//
//  CreateRoomRepository.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/23/21.
//

import Combine

protocol CreateRoomRepository: APIRepository {
    func create(room: CreateRoomDTO) -> AnyPublisher<None, ErrorEntity>
}

struct DefaultCreateRoomRepository: CreateRoomRepository {
    func create(room: CreateRoomDTO) -> AnyPublisher<None, ErrorEntity> {
        call(with: requestBuilder
                       .set(path: "/rooms")
                       .set(method: HTTPMethodPost())
                       .set(contentType: ContentTypeJson())
                       .setBody(json: room))
    }
}

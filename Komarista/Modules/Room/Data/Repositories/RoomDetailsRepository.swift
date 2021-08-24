//
//  RoomDetailsRepository.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/24/21.
//

import Combine

protocol RoomDetailsRepository: APIRepository {
    func details(of room: String) -> AnyPublisher<RoomDetailed, ErrorEntity>
}

struct DefaultRoomDetailsRepository: RoomDetailsRepository {
    func details(of room: String) -> AnyPublisher<RoomDetailed, ErrorEntity> {
        call(with: requestBuilder
                       .set(path: "/rooms/details/\(room)")
                       .set(method: HTTPMethodGet()))
    }
}

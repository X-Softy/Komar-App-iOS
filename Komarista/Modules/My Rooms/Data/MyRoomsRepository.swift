//
//  MyRoomsRepository.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/22/21.
//

import Combine

protocol MyRoomsRepository: APIRepository {
    func rooms() -> AnyPublisher<[RoomBrief], ErrorEntity>
}

struct DefaultMyRoomsRepository: MyRoomsRepository {
    func rooms() -> AnyPublisher<[RoomBrief], ErrorEntity> {
        call(with: requestBuilder
                       .set(path: "/rooms/user")
                       .set(method: HTTPMethodGet()))
    }
}

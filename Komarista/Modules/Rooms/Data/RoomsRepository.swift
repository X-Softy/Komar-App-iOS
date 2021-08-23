//
//  RoomsRepository.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/23/21.
//

import Combine

protocol RoomsRepository: APIRepository {
    func rooms(categoryId: String) -> AnyPublisher<[RoomBrief], ErrorEntity>
}

struct DefaultRoomsRepository: RoomsRepository {
    func rooms(categoryId: String) -> AnyPublisher<[RoomBrief], ErrorEntity> {
        call(with: requestBuilder
                       .set(path: "/rooms/category/\(categoryId)")
                       .set(method: HTTPMethodGet()))
    }
}

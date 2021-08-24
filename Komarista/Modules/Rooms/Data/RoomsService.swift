//
//  RoomsService.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/23/21.
//

import Combine
import SwiftUI

protocol RoomsService {
    mutating func rooms(categoryId: String, _ rooms: Binding<Loadable<[RoomBrief]>>)
}

struct DefaultRoomsService: RoomsService {
    private let roomsRepository: RoomsRepository = DefaultRoomsRepository()
    private var cancelBag = CancelBag()

    mutating func rooms(categoryId: String, _ rooms: Binding<Loadable<[RoomBrief]>>) {
        rooms.wrappedValue = .isLoading
        roomsRepository.rooms(categoryId: categoryId)
            .sinkToLoadable { rooms.wrappedValue = $0 }
            .store(in: &cancelBag)
    }
}

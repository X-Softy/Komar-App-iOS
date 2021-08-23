//
//  MyRoomsService.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/22/21.
//

import Combine
import SwiftUI

protocol MyRoomsService {
    mutating func rooms(_ rooms: LoadableSubject<[RoomBrief]>)
}

struct DefaultMyRoomsService: MyRoomsService {
    private let roomsRepository: MyRoomsRepository = DefaultMyRoomsRepository()
    private var cancelBag = CancelBag()

    mutating func rooms(_ rooms: LoadableSubject<[RoomBrief]>) {
        rooms.wrappedValue = .isLoading
        roomsRepository.rooms()
            .sinkToLoadable { rooms.wrappedValue = $0 }
            .store(in: &cancelBag)
    }
}

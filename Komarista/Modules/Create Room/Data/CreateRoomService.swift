//
//  CreateRoomService.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/23/21.
//
import Combine
import SwiftUI

protocol CreateRoomService {
    mutating func create(room: CreateRoomDTO, _ created: Binding<Loadable<None>>)
}

struct DefaultCreateRoomService: CreateRoomService {
    private let createRoomRepository: CreateRoomRepository = DefaultCreateRoomRepository()
    private var cancelBag = CancelBag()

    mutating func create(room: CreateRoomDTO, _ created: Binding<Loadable<None>>) {
        created.wrappedValue = .isLoading
        createRoomRepository.create(room: room)
            .sinkToLoadable { created.wrappedValue = $0 }
            .store(in: &cancelBag)
    }
}

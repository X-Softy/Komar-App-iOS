//
//  CreateRoomService.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/23/21.
//
import Combine
import SwiftUI

protocol CreateRoomService {
    mutating func create(room: CreateRoomDTO, _ created: Binding<Loadable<Void>>)
}

struct DefaultCreateRoomService: CreateRoomService {
    private let createRoomRepository: CreateRoomRepository = DefaultCreateRoomRepository()
    private var cancelBag = CancelBag()

    mutating func create(room: CreateRoomDTO, _ created: Binding<Loadable<Void>>) {
        created.wrappedValue = .isLoading
        createRoomRepository.create(room: room)
            .sinkToLoadable { _ in created.wrappedValue = .loaded(()) }
            .store(in: &cancelBag)
    }
}

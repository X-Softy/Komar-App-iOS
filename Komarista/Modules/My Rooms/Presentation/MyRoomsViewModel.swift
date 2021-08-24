//
//  MyRoomsViewModel.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/22/21.
//

import Combine
import SwiftUI

extension MyRooms {
    class ViewModel: ObservableObject {
        @Published var rooms: Loadable<[RoomBrief]> = .notRequested
        @Published var error: ErrorEntity? = nil
        private var roomsService: MyRoomsService = DefaultMyRoomsService()

        func loadRooms() {
            roomsService.rooms(loadableSubject(\.rooms))
        }
    }
}

//
//  RoomsViewModel.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/23/21.
//

import Combine
import SwiftUI

extension Rooms {
    class ViewModel: ObservableObject {
        @Published var rooms: Loadable<[RoomBrief]> = .notRequested
        @Published var error: ErrorEntity? = nil
        let category: Category
        private var roomsService: RoomsService = DefaultRoomsService()

        init(of category: Category) {
            self.category = category
        }

        func loadRooms() {
            roomsService.rooms(categoryId: category.id, subject(\.rooms))
        }
    }
}

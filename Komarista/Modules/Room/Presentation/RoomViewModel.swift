//
//  RoomViewModel.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/23/21.
//

import Combine
import SwiftUI

extension Room {
    class ViewModel: ObservableObject {
        @Published var details: Loadable<RoomDetailed> = .notRequested
        @Published var button: Button = .inactive
        @Published var error: ErrorEntity? = nil
        let params: Params
        private var roomService: RoomService = DefaultRoomService()

        enum Button {
            case inactive
         // active:
            case join
            case unjoin
            case delete
        }

        struct Params {
            let room: RoomBrief
            let onDisappear: (() -> Void)?

            init(room: RoomBrief, onDisappear: (() -> Void)? = nil) {
                self.room = room
                self.onDisappear = onDisappear
            }
        }

        init(with params: Params) {
            self.params = params
        }

        func loadDetails() {
            roomService.details(of: params.room.id, subject(\.details), subject(\.button))
        }
    }
}

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
        let room: RoomBrief
        private lazy var roomService: RoomService = DefaultRoomService(room: room)
        private var cancelBag = CancelBag()

        enum Button: String {
            case inactive
         // active:
            case join
            case unjoin
            case delete
        }

        struct Dismissable {
            let entity: ErrorEntity
            let dismiss: Bool

            init(entity: ErrorEntity, dismiss: Bool = false) {
                self.entity = entity
                self.dismiss = dismiss
            }
        }

        init(room: RoomBrief) {
            self.room = room
        }

        func loadDetails() {
            roomService.details(subject(\.details), subject(\.button))
        }

        func action() {
            switch button {
            case .delete: roomService.delete(subject(\.button), subject(\.error))
            case .join:   roomService.join(subject(\.button), subject(\.error))
            case .unjoin: roomService.unjoin(subject(\.button), subject(\.error))
            case .inactive: break
            }
        }
    }
}

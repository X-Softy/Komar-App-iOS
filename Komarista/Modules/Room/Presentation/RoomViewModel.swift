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
        @Published private var dismissable: Dismissable? = nil
        @Published var error: ErrorEntity? = nil
        var dismiss = false
        let params: Params
        private lazy var roomService: RoomService = DefaultRoomService(room: params.room)
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

            $dismissable.sink { [weak self] in
                guard let self = self else { return }
                guard let dismissable = $0 else {
                    self.error = nil
                    return
                }
                self.dismiss = dismissable.dismiss
                self.error = dismissable.entity
            }
            .store(in: &cancelBag)
        }

        func loadDetails() {
            roomService.details(subject(\.details), subject(\.button))
        }

        func action() {
            switch button {
            case .delete: roomService.delete(subject(\.button), subject(\.dismissable))
            case .join:   roomService.join(subject(\.button), subject(\.dismissable))
            case .unjoin: roomService.unjoin(subject(\.button), subject(\.dismissable))
            case .inactive: break
            }
        }
    }
}

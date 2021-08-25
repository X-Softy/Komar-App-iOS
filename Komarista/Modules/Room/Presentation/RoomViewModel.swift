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
        @Published var comments: [RoomDetailed.Comment] = []
        @Published var button: Button = .inactive
        @Published var comment: String = ""
        @Published var disabled: Bool = true
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

        init(room: RoomBrief) {
            self.room = room

            $details
                .sink { [weak self] details in
                    if case .loaded(let details) = details {
                        self?.comments = details.comments
                    }
                }
                .store(in: &cancelBag)

            Publishers.CombineLatest($button, $comment)
                .sink { [weak self] button, comment in
                    guard let self = self else { return }
                    switch button {
                    case .inactive, .join: self.disabled = true
                    case .unjoin, .delete: self.disabled = comment.isEmpty
                    }
                }
                .store(in: &cancelBag)
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

        func send() {
            roomService.add(comment: comment, subject(\.comments), subject(\.disabled), subject(\.error))
        }
    }
}

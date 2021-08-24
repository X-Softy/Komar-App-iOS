//
//  RoomService.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/24/21.
//

import Combine
import SwiftUI

protocol RoomService {
    mutating func details(_ details: Binding<Loadable<RoomDetailed>>,
                          _ button: Binding<Room.ViewModel.Button>)
    mutating func delete(_ button: Binding<Room.ViewModel.Button>,
                         _ error: Binding<Room.ViewModel.Dismissable?>)
    mutating func join(_ button: Binding<Room.ViewModel.Button>,
                       _ error: Binding<Room.ViewModel.Dismissable?>)
    mutating func unjoin(_ button: Binding<Room.ViewModel.Button>,
                         _ error: Binding<Room.ViewModel.Dismissable?>)
}

struct DefaultRoomService: RoomService {
    private let room: RoomBrief
    private let roomDetailsRepository: RoomDetailsRepository = DefaultRoomDetailsRepository()
    private let deleteRoomRepository: DeleteRoomRepository = DefaultDeleteRoomRepository()
    private let joinUserRepository: JoinUserRepository = DefaultJoinUserRepository()
    private let unjoinUserRepository: UnjoinUserRepository = DefaultUnjoinUserRepository()
    private let addCommentRepository: AddCommentRepository = DefaultAddCommentRepository()
    private let userSession: UserSession = .shared
    private var cancelBag = CancelBag()

    init(room: RoomBrief) {
        self.room = room
    }

    mutating func details(_ details: Binding<Loadable<RoomDetailed>>,
                          _ button: Binding<Room.ViewModel.Button>) {
        button.wrappedValue = .inactive
        roomDetailsRepository.details(of: room.id)
            .sinkToLoadable { [self] in
                guard let session = userSession.state else { return }
                details.wrappedValue = $0
                // set button state
                if case .loaded(let details) = $0 {
                    let userId = session.userId
                    if details.creatorUserId == userId {
                        button.wrappedValue = .delete
                    } else if details.joinedUserIds.contains(userId) {
                        button.wrappedValue = .unjoin
                    } else {
                        button.wrappedValue = .join
                    }
                }
            }
            .store(in: &cancelBag)
    }

    mutating func delete(_ button: Binding<Room.ViewModel.Button>,
                         _ error: Binding<Room.ViewModel.Dismissable?>) {
        button.wrappedValue = .inactive
        deleteRoomRepository.delete(room: room.id)
            .sink { completion in
                if case .failure(let entity) = completion {
                    button.wrappedValue = .delete
                    error.wrappedValue = .init(entity: entity)
                }
            } receiveValue: { _ in
                error.wrappedValue = .init(entity: .init(message: "room.delete.success".localized), dismiss: true)
            }
            .store(in: &cancelBag)
    }

    mutating func join(_ button: Binding<Room.ViewModel.Button>,
                       _ error: Binding<Room.ViewModel.Dismissable?>) {
        button.wrappedValue = .inactive
        joinUserRepository.join(to: room.id)
            .sink { completion in
                if case .failure(let entity) = completion {
                    button.wrappedValue = .join
                    error.wrappedValue = .init(entity: entity)
                }
            } receiveValue: { _ in
                button.wrappedValue = .unjoin
            }
            .store(in: &cancelBag)
    }

    mutating func unjoin(_ button: Binding<Room.ViewModel.Button>,
                         _ error: Binding<Room.ViewModel.Dismissable?>) {
        button.wrappedValue = .inactive
        unjoinUserRepository.unjoin(from: room.id)
            .sink { completion in
                if case .failure(let entity) = completion {
                    button.wrappedValue = .unjoin
                    error.wrappedValue = .init(entity: entity)
                }
            } receiveValue: { _ in
                button.wrappedValue = .join
            }
            .store(in: &cancelBag)
    }
}

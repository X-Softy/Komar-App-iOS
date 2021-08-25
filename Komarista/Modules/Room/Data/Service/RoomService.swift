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
                         _ error: Binding<ErrorEntity?>)
    mutating func join(_ button: Binding<Room.ViewModel.Button>,
                       _ error: Binding<ErrorEntity?>)
    mutating func unjoin(_ button: Binding<Room.ViewModel.Button>,
                         _ error: Binding<ErrorEntity?>)
    mutating func add(comment: String,
                      _ comments: Binding<[RoomDetailed.Comment]>,
                      _ disabled: Binding<Bool>,
                      _ error: Binding<ErrorEntity?>)
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
                         _ error: Binding<ErrorEntity?>) {
        button.wrappedValue = .inactive
        deleteRoomRepository.delete(room: room.id)
            .sink { completion in
                if case .failure(let cause) = completion {
                    button.wrappedValue = .delete
                    error.wrappedValue = cause
                }
            } receiveValue: { _ in
                error.wrappedValue = .init(message: "room.delete.success".localized)
            }
            .store(in: &cancelBag)
    }

    mutating func join(_ button: Binding<Room.ViewModel.Button>,
                       _ error: Binding<ErrorEntity?>) {
        button.wrappedValue = .inactive
        joinUserRepository.join(to: room.id)
            .sink { completion in
                if case .failure(let cause) = completion {
                    button.wrappedValue = .join
                    error.wrappedValue = cause
                }
            } receiveValue: { _ in
                button.wrappedValue = .unjoin
            }
            .store(in: &cancelBag)
    }

    mutating func unjoin(_ button: Binding<Room.ViewModel.Button>,
                         _ error: Binding<ErrorEntity?>) {
        button.wrappedValue = .inactive
        unjoinUserRepository.unjoin(from: room.id)
            .sink { completion in
                if case .failure(let cause) = completion {
                    button.wrappedValue = .unjoin
                    error.wrappedValue = cause
                }
            } receiveValue: { _ in
                button.wrappedValue = .join
            }
            .store(in: &cancelBag)
    }

    mutating func add(comment: String,
                      _ comments: Binding<[RoomDetailed.Comment]>,
                      _ disabled: Binding<Bool>,
                      _ error: Binding<ErrorEntity?>) {
        disabled.wrappedValue = true
        addCommentRepository.add(comment: comment, to: room.id)
            .sink { completion in
                if case .failure(let cause) = completion {
                    disabled.wrappedValue = false
                    error.wrappedValue = cause
                }
            } receiveValue: { [self] _ in
                guard let session = userSession.state else { return }
                let comment = RoomDetailed.Comment(userId: session.userId, comment: comment)
                comments.wrappedValue.append(comment)
            }
            .store(in: &cancelBag)
    }
}

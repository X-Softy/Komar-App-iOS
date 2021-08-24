//
//  RoomService.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/24/21.
//

import Combine
import SwiftUI

protocol RoomService {
    mutating func details(of room: String,
                          _ details: Binding<Loadable<RoomDetailed>>,
                          _ button: Binding<Room.ViewModel.Button>)
}

struct DefaultRoomService: RoomService {
    private let roomDetailsRepository: RoomDetailsRepository = DefaultRoomDetailsRepository()
    private let deleteRoomRepository: DeleteRoomRepository = DefaultDeleteRoomRepository()
    private let joinUserRepository: JoinUserRepository = DefaultJoinUserRepository()
    private let unjoinUserRepository: UnjoinUserRepository = DefaultUnjoinUserRepository()
    private let addCommentRepository: AddCommentRepository = DefaultAddCommentRepository()
    private let userSession: UserSession = .shared
    private var cancelBag = CancelBag()

    mutating func details(of room: String,
                          _ details: Binding<Loadable<RoomDetailed>>,
                          _ button: Binding<Room.ViewModel.Button>) {
        button.wrappedValue = .inactive
        roomDetailsRepository.details(of: room)
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
}

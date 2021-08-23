//
//  UserSession.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/18/21.
//

import Combine

class UserSession: ObservableObject {
    struct State {
        let authorization: String
        let userId: String
    }

    @Published var state: State? = nil

    static var shared: UserSession = .init()

    private init() {}
}

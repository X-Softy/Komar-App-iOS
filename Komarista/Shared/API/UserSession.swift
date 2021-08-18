//
//  UserSession.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/18/21.
//

import Foundation

class UserSession {
    private(set) var authorization: String? = nil
    private(set) var userId: String? = nil

    static var shared: UserSession = .init()

    private init() {}

    func set(authorization: String?, userId: String?) {
        self.authorization = authorization
        self.userId = userId
    }
}

//
//  AuthService.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/21/21.
//

import SwiftUI

protocol AuthService {
    func signIn(_ signedIn: LoadableSubject<Bool>)
}

struct DefaultAuthService: AuthService {
    let authRepository: AuthRepository = DefaultAuthRepository.shared

    func signIn(_ signedIn: LoadableSubject<Bool>) {
        signedIn.wrappedValue = .isLoading
        authRepository.signIn { result in
            switch result {
            case .success:
                signedIn.wrappedValue = .loaded(true)
            case .failure(let error):
                signedIn.wrappedValue = .failed(error)
            }
        }
    }
}

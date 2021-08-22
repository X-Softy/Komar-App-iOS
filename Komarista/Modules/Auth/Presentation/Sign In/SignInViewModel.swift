//
//  SignInViewModel.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/21/21.
//

import Combine

extension SignIn {
    class ViewModel: ObservableObject {
        @Published var signedIn: Loadable<Bool> = .notRequested
        @Published var error: ErrorEntity? = nil
        private var cancelables = CancelBag()
        private let authService: AuthService = DefaultAuthService()

        init() {
            $signedIn
                .sink {
                    switch $0 {
                    case .loaded(let signedIn):
                        if signedIn {
                            // navigate to categories page
                        }
                    case .failed(let error):
                        self.error = error
                    default: break
                    }
                }
                .store(in: &cancelables)
        }

        func signIn() {
            authService.signIn(loadableSubject(\.signedIn))
        }
    }
}

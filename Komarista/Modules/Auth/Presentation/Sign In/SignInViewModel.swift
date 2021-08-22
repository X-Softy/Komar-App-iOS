//
//  SignInViewModel.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/21/21.
//

import Combine
import SwiftUI

extension SignIn {
    class ViewModel: ObservableObject {
        // View state
        @Published var disabled: Bool
        @Published var label: LocalizedStringKey
        @Published var error: ErrorEntity?
        // View model state
        @Published private var signedIn: Loadable<Bool>

        private let authService: AuthService = DefaultAuthService()
        private var cancelables = CancelBag()

        init() {
            let signedIn: Loadable<Bool> = .notRequested // default value
            let (disabled, label, error) = signedIn.toViewState()

            _signedIn = .init(initialValue: signedIn)
            _disabled = .init(initialValue: disabled)
            _label    = .init(initialValue: label)
            _error    = .init(initialValue: error)

            $signedIn
                .sink { [weak self] in self?.handle(signedIn: $0) }
                .store(in: &cancelables)
        }

        func signIn() {
            authService.signIn(loadableSubject(\.signedIn))
        }

        private func handle(signedIn: Loadable<Bool>) {
            refreshViewState(from: signedIn)
            if case .loaded(let signedIn) = signedIn, signedIn {
                // navigate to categories page
            }
        }

        private func refreshViewState(from signedIn: Loadable<Bool>) {
            let (disabled, label, error) = signedIn.toViewState()
            self.disabled = disabled
            self.label    = label
            self.error    = error
        }
    }
}

fileprivate extension Loadable {
    func toViewState() -> (Bool, LocalizedStringKey, ErrorEntity?) where T == Bool {
        let prefix = "auth.sign.in.button."
        switch self {
        case .notRequested:         return (false,    "\(prefix)sign.in".asKey, nil)
        case .isLoading:            return (true,     "\(prefix)loading".asKey, nil)
        case .loaded(let signedIn): return (signedIn, "\(prefix)\(signedIn ? "signed.in" : "sign.in")".asKey, nil)
        case .failed(let error):    return (false,    "\(prefix)try.again".asKey, error)
        }
    }
}

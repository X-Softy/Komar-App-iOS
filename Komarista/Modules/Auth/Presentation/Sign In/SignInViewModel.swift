//
//  SignInViewModel.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/21/21.
//

import Combine

extension SignIn {
    class ViewModel: ObservableObject {
        // View state
        @Published var disabled: Bool
        @Published var label: String
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
    func toViewState() -> (Bool, String, ErrorEntity?) where T == Bool {
        switch self {
        case .notRequested:         return (false, "Sign In", nil)
        case .isLoading:            return (true, "Loading", nil)
        case .loaded(let signedIn): return (signedIn, signedIn ? "Signed In" : "Sign In", nil)
        case .failed(let error):    return (false, "Try Again", error)
        }
    }
}

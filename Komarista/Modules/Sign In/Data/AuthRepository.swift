//
//  AuthRepository.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/18/21.
//

import Foundation
import Firebase
import GoogleSignIn

protocol AuthRepository {
    typealias SignInCallback = (Result<Void, ErrorEntity>) -> Void
    func signIn(_ callback: @escaping SignInCallback)
    func signOut()
}

class DefaultAuthRepository: NSObject, GIDSignInDelegate, AuthRepository {
    private var callback: SignInCallback? = nil
    private let gidSignIn: GIDSignIn? = GIDSignIn.sharedInstance()
    private let userSession: UserSession = .shared

    static var shared: AuthRepository = DefaultAuthRepository()

    override private init() {
        super.init()
    }

    func signIn(_ callback: @escaping SignInCallback) {
        self.callback = callback
        gidSignIn?.signIn()
    }

    func signOut() {
        userSession.state = nil
        gidSignIn?.signOut()
    }

    func sign(_ signIn: GIDSignIn?, didSignInFor user: GIDGoogleUser?, withError error: Error?) {
        if let error = error {
            return failure(.init(from: error))
        }

        guard let authentication = user?.authentication,
              let idToken = authentication.idToken,
              let userId = user?.profile?.email
        else {
            return failure(.init())
        }

        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: authentication.accessToken)

        Auth.auth().signIn(with: credential) { [weak self] authResult, error in
            guard let self = self else { return }

            if let error = error {
                return self.failure(.init(from: error))
            }

            Auth.auth().currentUser?.getIDToken(completion: { [weak self] result, error in
                guard let self = self else { return }
                guard let authorization = result else { return self.failure(.init()) }

                if let error = error {
                    return self.failure(.init(from: error))
                }

                self.userSession.state = .init(authorization: authorization, userId: userId)

                return self.success()
            })
        }
    }

    private func success() {
        clean()?(.success(()))
    }

    private func failure(_ error: ErrorEntity) {
        clean()?(.failure(error))
    }

    private func clean() -> SignInCallback? {
        let callback = self.callback
        self.callback = nil
        return callback
    }
}

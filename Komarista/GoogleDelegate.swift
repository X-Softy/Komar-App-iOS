//
//  GoogleDelegate.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/7/21.
//

import Firebase
import GoogleSignIn

// TODO: Add as repository
class GoogleDelegate: NSObject, GIDSignInDelegate, ObservableObject {
    @Published var signedIn: Bool = false

    func sign(_ signIn: GIDSignIn?, didSignInFor user: GIDGoogleUser?, withError error: Error?) {
        if let _ = error {
            return
        }

        guard let authentication = user?.authentication,
              let idToken = authentication.idToken
        else {
            return
        }

        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: authentication.accessToken)

        Auth.auth().signIn(with: credential) { authResult, error in
            if let _ = error {
                return
            }

            Auth.auth().currentUser?.getIDToken(completion: { result, error in
                if let _ = error {
                    return
                }
                self.signedIn = true
                print("Token:", result ?? "nil")
            })
        }
    }
}

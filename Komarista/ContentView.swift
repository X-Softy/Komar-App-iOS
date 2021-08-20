//
//  ContentView.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/7/21.
//

import SwiftUI
import GoogleSignIn
import Combine

struct ContentView: View {
    @State var signedIn: Bool = false
    private let auth: AuthRepository = DefaultAuthRepository.shared
    private let userSession: UserSession = .shared
    private let foo = FooRepository()

    class FooRepository: APIRepository {
        var bag: Set<AnyCancellable> = .init()

        struct Bar: Decodable {
            let id: String
            let title: String
        }

        func foo() -> AnyPublisher<[Bar], ErrorEntity> {
            call(with: requestBuilder
                           .set(path: "/rooms/details/vhw1mIIYqNfgWDlP7bfW12")
                           .set(method: HTTPMethodGet()))
        }
    }

    var body: some View {
        Group {
            if signedIn {
                VStack {
                    Button(action: {
                        auth.signOut()
                        print("Debug.SignIn: success:", userSession.userId ?? "nil", userSession.authorization ?? "nil")
                        signedIn = false
                    }) {
                        Text("Sign Out")
                    }
                }
            } else {
                Button(action: {
                    auth.signIn { result in
                        switch result {
                        case .success:
                            print("Debug.SignIn: success:", userSession.userId ?? "nil", userSession.authorization ?? "nil")
                            categories()
                        case .failure(let error):
                            print("Debug.SignIn: failure:", error.localizedDescription)
                        }
                    }
                }) {
                    Text("Sign In")
                }
            }
        }
    }

    func categories() {
        foo.foo()
            .sink { completion in
                switch completion {
                case .finished:
                    print("Debug.Categories: success")
                case .failure(let error):
                    print("Debug.Categories: failure:", error.localizedDescription)
                }
            } receiveValue: { categories in
                print("Debug.Categories: success:", categories)
                signedIn = true
            }
            .store(in: &foo.bag)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

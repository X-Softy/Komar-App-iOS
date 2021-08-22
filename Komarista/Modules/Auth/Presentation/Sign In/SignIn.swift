//
//  SignIn.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/21/21.
//

import SwiftUI

struct SignIn: View {
    @ObservedObject private(set) var viewModel: ViewModel

    var body: some View {
        let (disabled, label) = state()
        Button {
            viewModel.signIn()
        } label: {
            Text(label)
        }
        .disabled(disabled)
        .alert(item: $viewModel.error) {
            Alert(title: Text($0.message),
                  dismissButton: .default(Text("OK")))
        }
    }

    private func state() -> (Bool, String) {
        switch viewModel.signedIn {
        case .notRequested:         return (false, "Sign In")
        case .isLoading:            return (true, "Loading")
        case .loaded(let signedIn): return (signedIn, signedIn ? "Signed In" : "Sign In")
        case .failed:               return (false, "Try Again")
        }
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn(viewModel: .init())
    }
}

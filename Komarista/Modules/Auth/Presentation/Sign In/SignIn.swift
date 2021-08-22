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
        Button {
            viewModel.signIn()
        } label: {
            Text(viewModel.label)
        }
        .disabled(viewModel.disabled)
        .alert(error: $viewModel.error)
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn(viewModel: .init())
    }
}

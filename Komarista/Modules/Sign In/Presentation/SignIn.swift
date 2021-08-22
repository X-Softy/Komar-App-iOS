//
//  SignIn.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/21/21.
//

import SwiftUI

struct SignIn: View {
    @ObservedObject private var viewModel: ViewModel = .init()

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: Home(), isActive: $viewModel.navigate2Home) {
                    EmptyView()
                }
                Button {
                    viewModel.signIn()
                } label: {
                    Text(viewModel.label)
                }
                .disabled(viewModel.disabled)
                .alert(error: $viewModel.error)
            }
        }
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn()
    }
}

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
        HStack {
            Spacer().frame(width: 16)
            VStack {
                Spacer()
                Button {
                    viewModel.signIn()
                } label: {
                    HStack {
                        Spacer().frame(width: 16)
                        Image("Pages/Login/google")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32)
                        Spacer()
                        Text(viewModel.label)
                            .font(.headline)
                        Spacer()
                    }
                }
                .disabled(viewModel.disabled)
                .frame(height: 64)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(16)
                Spacer().frame(height: 128)
            }
            .frame(maxWidth: .infinity)
            Spacer().frame(width: 16)
        }
        .background(
            Image("Pages/Login/background")
                .resizable()
                .scaledToFill()
                .clipped()
                .edgesIgnoringSafeArea(.all)
        )
        .alert(error: $viewModel.error)
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn()
            .previewDevice("iPhone 12")
    }
}

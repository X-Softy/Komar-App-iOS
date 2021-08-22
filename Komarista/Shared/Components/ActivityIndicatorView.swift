//
//  ActivityIndicatorView.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/23/21.
//

import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicatorView>) -> UIActivityIndicatorView {
        UIActivityIndicatorView(style: .large)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicatorView>) {
        uiView.startAnimating()
    }
}

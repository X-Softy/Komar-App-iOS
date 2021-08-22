//
//  View+Extension.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/22/21.
//

import SwiftUI

extension View {
    func alert(error: Binding<ErrorEntity?>) -> some View {
        alert(item: error) {
            .init(title: .init($0.message),
                  dismissButton: .default(.init("OK")))
        }
    }
}

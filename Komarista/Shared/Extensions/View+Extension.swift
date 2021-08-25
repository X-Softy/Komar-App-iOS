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
            .init(title: .init(verbatim: $0.message), // message is already localized
                               dismissButton: .default(.init("error.alert.dismiss.title")))
        }
    }
}

extension View {
    func content<DataType, ViewType: View>(
        of loadable: Loadable<DataType>,
        _ error: Binding<ErrorEntity?>,
        _ loaded: @escaping (DataType) -> ViewType
    ) -> AnyView {
        switch loadable {
        case .notRequested, .isLoading:
            return AnyView(loader)
        case .loaded(let data):
            return AnyView(loaded(data))
        case .failed(let cause):
            error.wrappedValue = cause
            return AnyView(self.error)
        }
    }

    var loader: some View { ActivityIndicatorView() }
    var error: some View { EmptyView() }
}

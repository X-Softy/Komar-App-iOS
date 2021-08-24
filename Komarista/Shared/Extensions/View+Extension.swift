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
        listen: Loadable<DataType>,
        call: @escaping () -> Void,
        error entity: Binding<ErrorEntity?>,
        receive: @escaping (DataType) -> ViewType
    ) -> AnyView {
        switch listen {
        case .notRequested, .isLoading:
            return AnyView(loadingView(onAppear: call))
        case .loaded(let data):
            return AnyView(receive(data))
        case .failed(let error):
            entity.wrappedValue = error
            return AnyView(errorView)
        }
    }

    func loadingView(onAppear: (() -> Void)? = nil) -> some View {
        ActivityIndicatorView()
            .onAppear(perform: onAppear)
    }

    var errorView: some View {
        EmptyView()
    }
}

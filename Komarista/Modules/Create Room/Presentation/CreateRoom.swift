//
//  CreateRoom.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/23/21.
//

import SwiftUI

struct CreateRoom: View {
    @ObservedObject private var viewModel: ViewModel = .init()
    @State private var error: ErrorEntity? = nil

    var body: some View {
        Group { content }
            .navigationBarTitle("create.room.bar.title")
            .alert(error: $error)
    }

    private var content: AnyView {
        switch viewModel.categories {
        case .notRequested, .isLoading:
            return AnyView(loadingView)
        case .loaded(let categories):
            return AnyView(list(categories: categories))
        case .failed(let error):
            self.error = error
            return AnyView(errorView)
        }
    }

    private func list(categories: [Category]) -> some View {
        Form {
            Section {
                Picker("create.room.picker.title", selection: $viewModel.selectedCategory) {
                    Text("create.room.picker.initial")
                    ForEach(categories) {
                        Text($0.title)
                    }
                }.pickerStyle(WheelPickerStyle())
            }
            Section {
                TextField("create.room.title.placeholder", text: $viewModel.title)
                TextField("create.room.description.placeholder", text: $viewModel.description)
            }
            Button(action: viewModel.createRoom, label: {
                Text("create.room.button.title")
            }).disabled(viewModel.disabled)
        }
    }

    private var loadingView: some View {
        ActivityIndicatorView()
            .onAppear(perform: viewModel.loadCategoryList)
    }

    private var errorView: some View {
        EmptyView()
    }
}

struct CreateRoom_Previews: PreviewProvider {
    static var previews: some View {
        CreateRoom()
    }
}

//
//  CreateRoom.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/23/21.
//

import SwiftUI

struct CreateRoom: View {
    @ObservedObject private(set) var viewModel: ViewModel

    var body: some View {
        Group {
            content(
                listen: viewModel.categories,
                call: viewModel.loadCategoryList,
                error: $viewModel.error
            ) { categories in
                Form {
                    Section {
                        Picker("create.room.picker.title", selection: $viewModel.selectedCategory) {
                            Text("create.room.category.placeholder")
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
        }
        .navigationBarTitle("create.room.bar.title")
        .onDisappear(perform: viewModel.params.onDisappear)
        .alert(error: $viewModel.error)
    }
}

struct CreateRoom_Previews: PreviewProvider {
    static var previews: some View {
        CreateRoom(viewModel: .init())
    }
}

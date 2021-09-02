//
//  CreateRoom.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/23/21.
//

import SwiftUI

struct CreateRoom: View {
    @ObservedObject private(set) var viewModel: ViewModel = .init()

    var body: some View {
        ZStack {
            content(of: viewModel.categories, $viewModel.error) { categories in
                Form {
                    Section {
                        Picker("create.room.picker.title", selection: $viewModel.selectedCategory) {
                            Text("create.room.category.placeholder")
                            ForEach(categories) { category in
                                HStack {
                                    Image(uiImage: UIImage(data: category.image ?? Data()) ?? UIImage())
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 28, height: 28)
                                    Text(category.title)
                                }
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .listRowInsets(EdgeInsets())
                    }
                    Section(header: Text("create.room.title")
                                        .font(.headline))
                    {
                        Group {
                            HStack {
                                Spacer().frame(width: 16)
                                VStack {
                                    Spacer().frame(height: 16)
                                    TextField("create.room.title.placeholder", text: $viewModel.title)
                                    Spacer().frame(height: 16)
                                }
                                Spacer().frame(width: 16)
                            }
                            .cornerRadius(8)
                            .listRowInsets(EdgeInsets())
                        }
                        .background(Color.clear)
                    }
                    Section(header: Text("create.room.description")
                                        .font(.headline)
                    ) {
                        Group {
                            HStack {
                                Spacer().frame(width: 16)
                                VStack {
                                    Spacer().frame(height: 16)
                                    // if #available(iOS 14.0, *) {
                                    //    TextEditor(text: $viewModel.description)
                                    //        .frame(height: 96)
                                    // } else {
                                        TextField("create.room.description.placeholder", text: $viewModel.description)
                                    // }
                                    Spacer().frame(height: 16)
                                }
                                Spacer().frame(width: 16)
                            }
                            .cornerRadius(8)
                            .listRowInsets(EdgeInsets())
                        }
                        .background(Color.clear)
                    }
                    Section {
                        Button(action: viewModel.createRoom, label: {
                            Text("create.room.button.title")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .frame(height: 54)
                                .background(viewModel.disabled ? Color(UIColor.systemGray5) : Color._tertiary)
                                .cornerRadius(8)
                        })
                        .disabled(viewModel.disabled)
                        .listRowInsets(EdgeInsets())
                    }
                }
            }
        }
        .navigationBarTitle("create.room.bar.title")
        .alert(error: $viewModel.error)
        .onAppear(perform: viewModel.loadCategoryList)
    }
}

struct CreateRoom_Previews: PreviewProvider {
    static var previews: some View {
        CreateRoom()
    }
}

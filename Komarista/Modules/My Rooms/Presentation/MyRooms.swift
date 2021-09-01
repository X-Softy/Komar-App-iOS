//
//  MyRooms.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/22/21.
//

import SwiftUI

struct MyRooms: View {
    @ObservedObject private var viewModel: ViewModel = .init()

    var body: some View {
        ZStack {
            content(of: viewModel.rooms, $viewModel.error) { rooms in
                VStack {
                    HStack {
                        ZStack {
                            NavigationLink(destination: CreateRoom()) {
                                ZStack {
                                    ZStack {
                                        Text("my.rooms.button.title")
                                            .foregroundColor(.primary)
                                            .font(.subheadline)
                                    }
                                    .frame(width: 124, height: 40)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color._primary, lineWidth: 1)
                                    )
                                }
                                .frame(width: 128, height: 44)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color._primary, lineWidth: 1)
                                )
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        ZStack {
                            Button(action: viewModel.signOut) {
                                ZStack {
                                    ZStack {
                                        Text("auth.sign.out.title")
                                            .foregroundColor(.primary)
                                            .font(.subheadline)
                                    }
                                    .frame(width: 124, height: 40)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color._secondary, lineWidth: 1)
                                    )
                                }
                                .frame(width: 128, height: 44)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color._secondary, lineWidth: 1)
                                )
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 64)
                    List {
                        ForEach(rooms) { room in
                            ZStack {
                                NavigationLink(destination: Room(viewModel: .init(room: room))) { EmptyView() }
                                    .frame(width: 0)
                                    .opacity(0)
                                RoomItem(title: room.title, description: room.description)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarTitle("my.rooms.bar.title")
        .alert(error: $viewModel.error)
        .onAppear(perform: viewModel.loadRooms)
    }
}

struct MyRooms_Previews: PreviewProvider {
    static var previews: some View {
        MyRooms()
    }
}

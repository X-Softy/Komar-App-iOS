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
                    NavigationLink(destination: CreateRoom()) {
                        Text("my.rooms.button.title")
                    }
                    Button(action: viewModel.signOut) { Text("auth.sign.out.title") }
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

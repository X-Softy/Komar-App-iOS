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
        Group {
            content(
                listen: viewModel.rooms,
                call: viewModel.loadRooms,
                error: $viewModel.error
            ) { rooms in
                VStack {
                    NavigationLink(destination: CreateRoom(viewModel: .init(with: .init(onDisappear: viewModel.loadRooms)))) {
                        Text("my.rooms.button.title")
                    }
                    List {
                        ForEach(rooms) { room in
                            NavigationLink(destination: Room(viewModel: .init(with: .init(room: room, onDisappear: viewModel.loadRooms)))) {
                                Text(room.title)
                            }
                        }
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarTitle("my.rooms.bar.title")
        .alert(error: $viewModel.error)
    }
}

struct MyRooms_Previews: PreviewProvider {
    static var previews: some View {
        MyRooms()
    }
}

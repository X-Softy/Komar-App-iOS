//
//  Rooms.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/23/21.
//

import SwiftUI

struct Rooms: View {
    @ObservedObject private(set) var viewModel: ViewModel

    var body: some View {
        ZStack {
            content(of: viewModel.rooms, $viewModel.error) { rooms in
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
        .navigationBarTitle("rooms.bar.title")
        .alert(error: $viewModel.error)
        .onAppear(perform: viewModel.loadRooms)
    }
}

struct Rooms_Previews: PreviewProvider {
    static var previews: some View {
        Rooms(viewModel: .init(of: .init(id: "ID", title: "Title", imageId: "ID")))
    }
}

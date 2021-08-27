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
                        NavigationLink(destination: Room(viewModel: .init(room: room))) {
                            Text(room.title)
                        }
                    }
                }
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

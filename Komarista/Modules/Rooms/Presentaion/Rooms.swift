//
//  Rooms.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/23/21.
//

import SwiftUI

struct Rooms: View {
    @ObservedObject private(set) var viewModel: ViewModel
    @State private var error: ErrorEntity? = nil

    var body: some View {
        VStack { content }
            .alert(error: $error)
            .navigationBarTitle("Rooms", displayMode: .inline)
    }

    private var content: AnyView {
        switch viewModel.rooms {
        case .notRequested, .isLoading:
            return AnyView(loadingView)
        case .loaded(let rooms):
            return AnyView(list(rooms: rooms))
        case .failed(let error):
            self.error = error
            return AnyView(errorView)
        }
    }

    private func list(rooms: [RoomBrief]) -> some View {
        List {
            ForEach(rooms) { room in
                NavigationLink(destination: Room(viewModel: .init(with: .init(room: room)))) {
                    Text(room.title)
                }
            }
        }
    }

    private var loadingView: some View {
        ActivityIndicatorView()
            .onAppear(perform: viewModel.loadRooms)
    }

    private var errorView: some View {
        EmptyView()
    }
}

struct Rooms_Previews: PreviewProvider {
    static var previews: some View {
        Rooms(viewModel: .init(of: .init(id: "ID", title: "Title")))
    }
}

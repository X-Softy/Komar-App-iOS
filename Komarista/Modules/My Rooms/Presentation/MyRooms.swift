//
//  MyRooms.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/22/21.
//

import SwiftUI

struct MyRooms: View {
    @ObservedObject private var viewModel: ViewModel = .init()
    @State private var error: ErrorEntity? = nil

    var body: some View {
        Group { content }
            .navigationBarTitle("my.rooms.bar.title")
            .alert(error: $error)
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
        VStack {
            NavigationLink(destination: CreateRoom()) { Text("Create Room") }
            List {
                ForEach(rooms) { room in
                    NavigationLink(destination: Room(viewModel: .init(with: .init(room: room)))) {
                        Text(room.title)
                    }
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

struct MyRooms_Previews: PreviewProvider {
    static var previews: some View {
        MyRooms()
    }
}

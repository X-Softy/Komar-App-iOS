//
//  Room.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/23/21.
//

import SwiftUI

struct Room: View {
    @ObservedObject private(set) var viewModel: ViewModel

    var body: some View {
        Group { Text("Room: \(viewModel.params.room.title)") }
            .navigationBarTitle("room.bar.title")
            .onDisappear(perform: viewModel.params.onDisappear)
    }
}

struct Room_Previews: PreviewProvider {
    static var previews: some View {
        Room(viewModel: .init(with: .init(room: .init(id: "ID", title: "Title"))))
    }
}

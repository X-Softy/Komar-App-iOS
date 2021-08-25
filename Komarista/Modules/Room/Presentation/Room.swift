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
        ZStack {
            Button(action: viewModel.action) { Text(viewModel.button.rawValue) }
                .disabled(viewModel.button == .inactive)
        }
        .navigationBarTitle("room.bar.title")
        .alert(error: $viewModel.error)
        .onAppear(perform: viewModel.loadDetails)
    }
}

struct Room_Previews: PreviewProvider {
    static var previews: some View {
        Room(viewModel: .init(room: .init(id: "ID", title: "Title")))
    }
}

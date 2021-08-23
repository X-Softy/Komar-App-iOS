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
        Text("Room: \(viewModel.params.room.title)")
    }
}

struct Room_Previews: PreviewProvider {
    static var previews: some View {
        Room(viewModel: .init(with: .init(room: .init(id: "ID", title: "Title"))))
    }
}

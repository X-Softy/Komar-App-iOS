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
        Text("Rooms: \(viewModel.params.category.title)")
    }
}

struct Rooms_Previews: PreviewProvider {
    static var previews: some View {
        Rooms(viewModel: .init(with: .init(category: .init(id: "ID", title: "Title"))))
    }
}

//
//  Room.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/23/21.
//

import SwiftUI

struct Room: View {
    @ObservedObject private(set) var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        Group {
            Button(action: viewModel.action) { Text(viewModel.button.rawValue) }
                .disabled(viewModel.button == .inactive)
        }
        .navigationBarTitle("room.bar.title")
        .onDisappear(perform: viewModel.params.onDisappear)
        .alert(error: $viewModel.error, action: viewModel.dismiss ? { presentationMode.wrappedValue.dismiss() } : nil)
        .onAppear(perform: viewModel.loadDetails)
    }
}

struct Room_Previews: PreviewProvider {
    static var previews: some View {
        Room(viewModel: .init(with: .init(room: .init(id: "ID", title: "Title"))))
    }
}

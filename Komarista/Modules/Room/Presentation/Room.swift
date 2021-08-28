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
            content(of: viewModel.details, $viewModel.error) { details in
                VStack {
                    Image(uiImage: UIImage(data: viewModel.category?.image ?? Data()) ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text(viewModel.category?.title ?? "")
                    Button(action: viewModel.action) { Text(viewModel.button.rawValue) }
                        .disabled(viewModel.button == .inactive)
                    Text(details.title)
                    Text(details.description)
                    List {
                        ForEach(viewModel.comments) { comment in
                            HStack {
                                Text(comment.userId)
                                Text(comment.comment)
                            }
                        }
                    }
                    HStack {
                        TextField("room.comment.placeholder", text: $viewModel.comment)
                        Button(action: viewModel.send, label: {
                            Text("room.send.title")
                        }).disabled(viewModel.disabled)
                    }
                }
            }
        }
        .navigationBarTitle("room.bar.title")
        .alert(error: $viewModel.error)
        .onAppear(perform: viewModel.loadDetails)
    }
}

struct Room_Previews: PreviewProvider {
    static var previews: some View {
        Room(viewModel: .init(room: .init(id: "ID", title: "Title", description: "Description")))
    }
}

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
                    ScrollView {
                        HStack {
                            Spacer().frame(width: 16)
                            VStack(spacing: 16) {
                                ZStack(alignment: .bottomTrailing) {
                                    Image(uiImage: UIImage(data: viewModel.category?.image ?? Data()) ?? UIImage())
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 192)
                                        .frame(maxWidth: .infinity)
                                        .cornerRadius(16)
                                        .clipped()
                                    Button(action: viewModel.action) {
                                        Text(viewModel.button.rawValue)
                                            .foregroundColor(.primary)
                                            .font(.headline)
                                            .frame(width: 128, height: 44)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(Color._primary, lineWidth: 4)
                                            )
                                            .background(Color._secondary)
                                            .cornerRadius(16)
                                    }
                                    .disabled(viewModel.button == .inactive)
                                    .offset(x: -8, y: -8)
                                }
                                Text(details.title)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineLimit(2)
                                    .font(.title)
                                    .offset(x: 8, y: 0)
                                HStack {
                                    Spacer().frame(width: 12)
                                    VStack(alignment: .leading, spacing: 6) {
                                        Spacer().frame(height: 2)
                                        Text("Description")
                                            .font(.safeTitle3)
                                            .fontWeight(.bold)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text(details.description)
                                            .foregroundColor(.secondary)
                                        Spacer().frame(height: 4)
                                    }
                                    Spacer().frame(width: 12)
                                }
                                .frame(maxWidth: .infinity)
                                .background(Color._secondary)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color._tertiary, lineWidth: 4)
                                )
                                .cornerRadius(16)
                                Text("Comments")
                                    .font(.safeTitle2)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .offset(x: 12, y: 0)
                                if !viewModel.comments.isEmpty {
                                    HStack {
                                        Spacer().frame(width: 12)
                                        VStack(alignment: .leading, spacing: 8) {
                                            Spacer()
                                                .frame(height: 4)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            ForEach(viewModel.comments) { comment in
                                                VStack(spacing: 6) {
                                                    Text(comment.userId)
                                                        .foregroundColor(.secondary)
                                                        .font(.subheadline)
                                                        .fontWeight(.bold)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                    Text(comment.comment)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                }
                                                .frame(maxWidth: .infinity)
                                                .padding(12)
                                                .background(Color._secondary)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 16)
                                                        .stroke(Color._tertiary, lineWidth: 4)
                                                )
                                                .cornerRadius(16)
                                            }
                                            Spacer().frame(height: 4)
                                        }
                                        Spacer().frame(width: 12)
                                    }
                                    .background(Color._primary)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color._tertiary, lineWidth: 4)
                                    )
                                    .cornerRadius(16)
                                }
                                HStack {
                                    Spacer().frame(width: 4)
                                    HStack(spacing: 4) {
                                        HStack {
                                            Spacer().frame(width: 12)
                                            TextField("room.comment.placeholder", text: $viewModel.comment)
                                            Spacer().frame(width: 12)
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .background(Color._secondary)
                                        .cornerRadius(16)
                                        Button(action: viewModel.send, label: {
                                            ZStack {
                                                Color._tertiary
                                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                Image("Shared/chevron")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: 32)
                                                    .clipped()
                                            }
                                            .frame(width: 44)
                                            .frame(maxHeight: .infinity)
                                            .cornerRadius(16)
                                        }).disabled(viewModel.disabled)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 46)
                                    .cornerRadius(16)
                                    Spacer()
                                        .frame(width: 4)
                                }
                                .frame(height: 54)
                                .frame(maxWidth: .infinity)
                                .background(Color._primary)
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color._quaternary, lineWidth: 1)
                                )
                                Spacer()
                            }
                            Spacer().frame(width: 16)
                        }
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

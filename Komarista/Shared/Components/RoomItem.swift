//
//  RoomItem.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 31.08.21.
//

import SwiftUI

struct RoomItem: View {
    let title: String
    let description: String

    init(title: String, description: String) {
        self.title = title
        self.description = description
    }

    var body: some View {
        HStack {
            Spacer()
                .frame(width: 4)
            HStack(spacing: 4) {
                HStack {
                    Spacer()
                        .frame(width: 12)
                    VStack(alignment: .leading, spacing: 8) {
                        Spacer()
                            .frame(height: 0)
                        Text(title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(1)
                            .font(.title)
                        Text(description)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(3)
                            .font(.body)
                        Spacer()
                    }
                    Spacer()
                        .frame(width: 12)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.komaristaTertiary)
                .cornerRadius(16)
                ZStack {
                    Color.komaristaSecondary
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    Image("Shared/chevron")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 32)
                        .clipped()
                }
                .frame(width: 64)
                .frame(maxHeight: .infinity)
                .cornerRadius(16)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 130)
            .cornerRadius(16)
            Spacer()
                .frame(width: 4)
        }
        .frame(height: 138)
        .frame(maxWidth: .infinity)
        .background(Color.komaristaPrimary)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.komaristaSecondary, lineWidth: 1)
        )
    }
}

struct RoomItem_Previews: PreviewProvider {
    static var previews: some View {
        RoomItem(title: "Very Big Title For Room Item", description: "Very Big Description Fot Room Item Preview To See If Three Line Limit Is Working Or Not, Also Some Big Useless Text")
    }
}

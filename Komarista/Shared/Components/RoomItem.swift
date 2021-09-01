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
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(1)
                            .font(.safeTitle3)
                        Text(description)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(3)
                            .font(.footnote)
                        Spacer()
                    }
                    Spacer()
                        .frame(width: 12)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color._secondary)
                .cornerRadius(16)
                ZStack {
                    Color._tertiary
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
            .frame(height: 108)
            .cornerRadius(16)
            Spacer()
                .frame(width: 4)
        }
        .frame(height: 116)
        .frame(maxWidth: .infinity)
        .background(Color._primary)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color._secondary, lineWidth: 1)
        )
    }
}

struct RoomItem_Previews: PreviewProvider {
    static var previews: some View {
        RoomItem(title: "Very Big Title For Room Item", description: "Very Big Description Fot Room Item Preview To See If Three Line Limit Is Working Or Not, Also Some Big Useless Text Which Does Not Make Any Sence")
    }
}

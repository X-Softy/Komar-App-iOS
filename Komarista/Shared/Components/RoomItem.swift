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
            Spacer().frame(width: 4)
            HStack(spacing: 4) {
                HStack {
                    Spacer().frame(width: 16)
                    VStack(alignment: .leading, spacing: 8) {
                        Spacer().frame(height: 8)
                        Text(title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(1)
                            .font(.title)
                        Text(description)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(2)
                            .font(.body)
                        Spacer()
                    }
                    Spacer().frame(width: 16)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.yellow)
                .cornerRadius(16)
                ZStack {
                    Image("Pages/Home/category.list")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .background(Color.blue)
                .frame(width: 64)
                .frame(maxHeight: .infinity)
                .cornerRadius(16)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .cornerRadius(16)
            Spacer().frame(width: 4)
        }
        .frame(height: 128)
        .frame(maxWidth: .infinity)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.pink, lineWidth: 1)
        )
    }
}

struct RoomItem_Previews: PreviewProvider {
    static var previews: some View {
        RoomItem(title: "Very Big Title For Room Item", description: "Very Big Description Fot Room Item Preview To See If Two Line Limit Is Working")
    }
}

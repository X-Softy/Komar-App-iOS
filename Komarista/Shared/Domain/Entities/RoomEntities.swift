//
//  RoomEntities.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/23/21.
//

import Foundation

struct RoomBrief: Decodable, Identifiable {
    let id: String
    let title: String
}

struct RoomDetailed: Decodable, Identifiable {
    struct Comment: Decodable, Identifiable {
        var id: String { "\(userId)\(comment)" }
        let userId: String
        let comment: String
    }

    // Brief
    let id: String
    let title: String
    // Details
    let categoryId: String
    let creatorUserId: String
    let joinedUserIds: [String]
    let description: String
    let comments: [Comment]
}

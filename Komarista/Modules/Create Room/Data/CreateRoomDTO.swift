//
//  CreateRoomDTO.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/24/21.
//

import Foundation

struct CreateRoomDTO: Encodable {
    let categoryId: String
    let title: String
    let description: String
}

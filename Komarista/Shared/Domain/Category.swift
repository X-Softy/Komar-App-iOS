//
//  Category.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/22/21.
//

import Foundation

struct Category: Decodable, Identifiable {
    typealias ID = String
    let id: ID
    let title: String
}

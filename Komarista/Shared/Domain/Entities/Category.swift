//
//  Category.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/22/21.
//

import Foundation

struct Category: Decodable, Identifiable {
    let id: String
    let title: String
    let imageId: String
    var image: Data? = nil
}

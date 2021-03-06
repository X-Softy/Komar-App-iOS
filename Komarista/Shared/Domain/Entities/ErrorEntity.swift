//
//  ErrorEntity.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/20/21.
//

import Foundation

struct ErrorEntity: Decodable {
    let message: String // already localized

    init(message: String = "error.default.message".localized) {
        self.message = message
    }
}

extension ErrorEntity: Identifiable {
    var id: String { message }
}

extension ErrorEntity: LocalizedError {
    var errorDescription: String? { message }
}

extension ErrorEntity {
    init(from error: Error) {
        self.message = error.localizedDescription
    }
}

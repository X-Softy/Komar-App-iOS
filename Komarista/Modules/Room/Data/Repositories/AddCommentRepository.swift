//
//  AddCommentRepository.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/24/21.
//

import Combine

protocol AddCommentRepository: APIRepository {
    func add(comment: String, to room: String) -> AnyPublisher<None, ErrorEntity>
}

struct DefaultAddCommentRepository: AddCommentRepository {
    func add(comment: String, to room: String) -> AnyPublisher<None, ErrorEntity> {
        call(with: requestBuilder
                       .set(path: "/rooms/comment/\(room)")
                       .set(method: HTTPMethodPatch())
                       .set(contentType: ContentTypeJSON())
                       .setBody(json: DTO(comment: comment)))
    }

    private struct DTO: Encodable {
        let comment: String
    }
}

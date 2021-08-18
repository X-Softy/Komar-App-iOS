//
//  APIRepository.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/18/21.
//

import Foundation
import Combine

protocol APIRepository: WebRepository {
    var requestBuilder: HostSetterReturnType { get }
    func call<Response: Decodable>(with requestBuilder: UrlRequestBuilderHTTPRequestBuilder) -> AnyPublisher<Response, Error>
}

extension APIRepository {
    private var factory: APIRequestBuilderFactory { .default }

    var requestBuilder: HostSetterReturnType { factory.requestBuilder }

    func call<Response: Decodable>(with requestBuilder: UrlRequestBuilderHTTPRequestBuilder) -> AnyPublisher<Response, Error> {
        let request = requestBuilder
            .build()
         // .setValue("Bearer ${Token}", forHTTPHeaderField: "Authorization")
        return call(request: request)
    }
}

// TODO: Delete
class FooRepository: APIRepository {
    struct Bar: Decodable {}

    func foo() -> AnyPublisher<Bar, Error> {
        call(with: requestBuilder
                       .set(path: "/categories")
                       .set(method: HTTPMethodGet()))
    }
}

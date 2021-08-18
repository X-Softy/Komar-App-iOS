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
    private var userSession: UserSession { .shared }

    var requestBuilder: HostSetterReturnType { factory.requestBuilder }

    func call<Response: Decodable>(with requestBuilder: UrlRequestBuilderHTTPRequestBuilder) -> AnyPublisher<Response, Error> {
        var request = requestBuilder
            .build()
        request.setValue("Bearer \(userSession.authorization ?? "")", forHTTPHeaderField: "Authorization")
        return call(request: request)
    }
}

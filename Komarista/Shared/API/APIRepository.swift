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
    func call<Response: Decodable>(with requestBuilder: UrlRequestBuilderHTTPRequestBuilder) -> AnyPublisher<Response, ErrorEntity>
}

extension APIRepository {
    private var factory: APIRequestBuilderFactory { .default }
    private var userSession: UserSession { .shared }

    var requestBuilder: HostSetterReturnType { factory.requestBuilder }

    func call<Response: Decodable>(with requestBuilder: UrlRequestBuilderHTTPRequestBuilder) -> AnyPublisher<Response, ErrorEntity> {
        var request = requestBuilder
            .build()
        request.setValue("Bearer \(userSession.state?.authorization ?? "")", forHTTPHeaderField: "Authorization")
        return call(request: request)
            .mapError { error in
                if case .invalidStatusCode(let code, let data) = error, [401, 406].contains(code) {
                    do { return try JSONDecoder().decode(ErrorEntity.self, from: data) } catch {}
                }
                return .init(message: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}

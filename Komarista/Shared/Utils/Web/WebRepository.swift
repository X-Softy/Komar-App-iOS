//
//  WebRepository.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/16/21.
//

import Foundation
import Combine

protocol WebRepository {
    var session: URLSession { get }
    func call<Response: Decodable>(request: URLRequest) -> AnyPublisher<Response, Error>
}

extension WebRepository {
    var session: URLSession { URLSession.shared }
    func call<Response: Decodable>(request: URLRequest) -> AnyPublisher<Response, Error> {
        session
            .dataTaskPublisher(for: request)
            .tryMap() { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200 ..< 300).contains(httpResponse.statusCode)
                else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: Response.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

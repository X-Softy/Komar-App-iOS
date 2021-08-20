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
    var successStatusCodes: Range<Int> { get }
    func call<Response: Decodable>(request: URLRequest) -> AnyPublisher<Response, WebErrorType>
}

extension WebRepository {
    var session: URLSession { URLSession.shared }
    var successStatusCodes: Range<Int> { 200 ..< 300 }
    func call<Response: Decodable>(request: URLRequest) -> AnyPublisher<Response, WebErrorType> {
        session
            .dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse
                else { throw WebErrorType.invalidResponse }

                guard successStatusCodes.contains(httpResponse.statusCode)
                else { throw WebErrorType.invalidStatusCode(code: httpResponse.statusCode, data: data) }

                return data
            }
            .decode(type: Response.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .mapError { error in
                switch error {
                case let webError as WebErrorType: return webError
                case let urlError as URLError:     return .urlError(error: urlError)
                case is Swift.DecodingError:       return .decodingError
                default:                           return .error(error: error)
                }
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Error
enum WebErrorType {
    case invalidResponse
    case invalidStatusCode(code: Int, data: Data)
    case decodingError
    case urlError(error: URLError)
    case error(error: Error)
}

extension WebErrorType: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidResponse:                return "Invalid response"
        case .invalidStatusCode(let code, _): return "Invalid status code: \(code)"
        case .decodingError:                  return "Decoding error"
        case .urlError(let error):            return "URL Error: \(error.localizedDescription)"
        case .error(let error):               return "Error: \(error.localizedDescription)"
        }
    }
}

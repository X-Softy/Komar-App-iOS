//
//  HTTPRequestBuilder.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/16/21.
//

import Foundation

/**

 Host --- Path --- URL Parameters? --- Headers? --- Method --- GET --- Build
                                                          '--- POST | PATCH | DELETE --- Content Type? --- Content? --- Build

 */

// Initial interface known to user
protocol HTTPRequestBuilder: BaseURLSetterHTTPRequestBuilder {}

// Interfaces known to user

/* Base URL */
protocol BaseURLSetterHTTPRequestBuilder {
    func set(baseURL: String) -> HostSetterReturnType
}

typealias HostSetterReturnType = PathSetterHTTPRequestBuilder &
                                 PathSetterReturnType

/* Path */
protocol PathSetterHTTPRequestBuilder {
    func set(path: String) -> PathSetterReturnType
}

typealias PathSetterReturnType = UrlParameterSetterHTTPRequestBuilder &
                                 HeaderSetterHTTPRequestBuilder &
                                 HTTPMethodSetterHTTPRequestBuilder

/* URL Parameters */
protocol UrlParameterSetterHTTPRequestBuilder {
    func set(urlParams: [String: String]) -> UrlParameterSetterReturnType
    func setUrlParam(key: String, value: String) -> UrlParameterSetterReturnType
}

typealias UrlParameterSetterReturnType = UrlParameterSetterHTTPRequestBuilder &
                                         HeaderSetterHTTPRequestBuilder &
                                         HTTPMethodSetterHTTPRequestBuilder

/* Headers */
protocol HeaderSetterHTTPRequestBuilder {
    func set(headers: [String: String]) -> HeaderSetterReturnType
    func setHeader(key: String, value: String) -> HeaderSetterReturnType
}

typealias HeaderSetterReturnType = HeaderSetterHTTPRequestBuilder &
                                   HTTPMethodSetterHTTPRequestBuilder

/* Method */
protocol HTTPMethodSetterHTTPRequestBuilder {
    func set<T: HTTPMethodTypeInfo>(method info: T) -> T.NextProtocol
}

/// Method Type associated description
protocol HTTPMethodTypeInfo {
    var method: HTTPMethodType { get }
    associatedtype NextProtocol
}

/// Method Types
enum HTTPMethodType: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

/// .get
struct HTTPMethodGet: HTTPMethodTypeInfo {
    let method: HTTPMethodType = .get
    typealias NextProtocol = UrlRequestBuilderHTTPRequestBuilder
}

/// .post
struct HTTPMethodPost: HTTPMethodTypeInfo {
    let method: HTTPMethodType = .post
    typealias NextProtocol = ContentTypeSetterHTTPRequestBuilder &
                             UrlRequestBuilderHTTPRequestBuilder
}

/// .patch
struct HTTPMethodPatch: HTTPMethodTypeInfo {
    let method: HTTPMethodType = .patch
    typealias NextProtocol = ContentTypeSetterHTTPRequestBuilder &
                             UrlRequestBuilderHTTPRequestBuilder
}

/// .delete
struct HTTPMethodDelete: HTTPMethodTypeInfo {
    let method: HTTPMethodType = .delete
    typealias NextProtocol = ContentTypeSetterHTTPRequestBuilder &
                             UrlRequestBuilderHTTPRequestBuilder
}

/* Content Type */
protocol ContentTypeSetterHTTPRequestBuilder {
    func set<T: ContentTypeInfo>(contentType info: T) -> T.NextProtocol
}

/// Content Type associated description
protocol ContentTypeInfo {
    var contentType: ContentType { get }
    associatedtype NextProtocol
}

/// Method Types
enum ContentType: String {
    case urlEncoded = "application/x-www-form-urlencoded"
    case json = "application/json"
    case raw = "text/plain"
}

/// .urlEncoded
struct ContentTypeUrlEncoded: ContentTypeInfo {
    let contentType: ContentType = .urlEncoded
    typealias NextProtocol = UrlEncodedContentSetterHTTPRequestBuilder &
                             UrlRequestBuilderHTTPRequestBuilder
}

/// .json
struct ContentTypeJSON: ContentTypeInfo {
    let contentType: ContentType = .json
    typealias NextProtocol = JsonContentSetterHTTPRequestBuilder &
                             UrlRequestBuilderHTTPRequestBuilder
}

/// .raw
struct ContentTypeRaw: ContentTypeInfo {
    let contentType: ContentType = .raw
    typealias NextProtocol = RawContentSetterHTTPRequestBuilder &
                             UrlRequestBuilderHTTPRequestBuilder
}

/* Content */
// Url Encoded Content
protocol UrlEncodedContentSetterHTTPRequestBuilder {
    func set(body: [String: String]) -> UrlEncodedContentSetterReturnType
    func setBody(key: String, value: String) -> UrlEncodedContentSetterReturnType
}

typealias UrlEncodedContentSetterReturnType = UrlEncodedContentSetterHTTPRequestBuilder &
                                              UrlRequestBuilderHTTPRequestBuilder

// Json Content
protocol JsonContentSetterHTTPRequestBuilder {
    func setBody<T: Encodable>(json obj: T) -> JsonContentSetterReturnType
}

typealias JsonContentSetterReturnType = UrlRequestBuilderHTTPRequestBuilder

// Raw Content
protocol RawContentSetterHTTPRequestBuilder {
    func setBody(raw data: Data) -> RawContentSetterReturnType
}

typealias RawContentSetterReturnType = UrlRequestBuilderHTTPRequestBuilder

/* Build */
protocol UrlRequestBuilderHTTPRequestBuilder {
    func build() -> URLRequest
}

fileprivate typealias HTTPRequestBuilderProtocols = HTTPRequestBuilder &
                                                    BaseURLSetterHTTPRequestBuilder &
                                                    PathSetterHTTPRequestBuilder &
                                                    UrlParameterSetterHTTPRequestBuilder &
                                                    HeaderSetterHTTPRequestBuilder &
                                                    HTTPMethodSetterHTTPRequestBuilder &
                                                    ContentTypeSetterHTTPRequestBuilder &
                                                    UrlEncodedContentSetterHTTPRequestBuilder &
                                                    JsonContentSetterHTTPRequestBuilder &
                                                    RawContentSetterHTTPRequestBuilder &
                                                    UrlRequestBuilderHTTPRequestBuilder

/**
 HTTPRequestBuilder Implementation
 */
class HTTPRequestBuilderImpl: HTTPRequestBuilderProtocols {
    private lazy var components = URLComponents()
    private lazy var request = URLRequest(url: components.url!) // while creating, *components* is already assembled
    private lazy var encoder = JSONEncoder()

    private init() {}

    static func createInstance() -> HTTPRequestBuilder {
        return HTTPRequestBuilderImpl()
    }

    // protocol implementations

    func set(baseURL: String) -> HostSetterReturnType {
        let url = URL(string: baseURL)!
        components.scheme = url.scheme
        components.host = url.host
        components.path = url.path
        return self
    }

    func set(path: String) -> PathSetterReturnType {
        components.path.append(path)
        return self
    }

    func set(urlParams: [String: String]) -> UrlParameterSetterReturnType {
        var builder: UrlParameterSetterHTTPRequestBuilder = self
        urlParams.forEach { key, value in
            builder = builder.setUrlParam(key: key, value: value)
        }
        return self
    }

    func setUrlParam(key: String, value: String) -> UrlParameterSetterReturnType {
        guard !key.isEmpty, !value.isEmpty else { return self }
        if components.queryItems == nil { components.queryItems = [] }
        components.queryItems?.append(.init(name: key, value: value))
        return self
    }

    func set(headers: [String: String]) -> HeaderSetterReturnType {
        var builder: HeaderSetterHTTPRequestBuilder = self
        headers.forEach { key, value in
            builder = builder.setHeader(key: key, value: value)
        }
        return self
    }

    func setHeader(key: String, value: String) -> HeaderSetterReturnType {
        guard key.lowercased() != "content-type"
        else { fatalError("Specify Content-Type using set(contentType:) method") }
        request.setValue(value, forHTTPHeaderField: key)
        return self
    }

    func set<T: HTTPMethodTypeInfo>(method info: T) -> T.NextProtocol {
        guard let self = self as? T.NextProtocol
        else { fatalError("Invalid call of set(method:), you must use only protocol specified 'HTTPMethodTypeInfo' implementations") }
        request.httpMethod = info.method.rawValue
        return self
    }

    func set<T: ContentTypeInfo>(contentType info: T) -> T.NextProtocol {
        guard let self = self as? T.NextProtocol
        else { fatalError("Invalid call of set(contentType:), you must use only protocol specified 'ContentTypeInfo' implementations") }
        request.setValue(info.contentType.rawValue, forHTTPHeaderField: "Content-Type")
        return self
    }

    func set(body: [String: String]) -> UrlEncodedContentSetterReturnType {
        var builder: UrlEncodedContentSetterHTTPRequestBuilder = self
        body.forEach { key, value in
            builder = builder.setBody(key: key, value: value)
        }
        return self
    }

    func setBody(key: String, value: String) -> UrlEncodedContentSetterReturnType {
        if let body = request.httpBody {
            var data: String = .init(decoding: body, as: UTF8.self)
            data = data.appending("&\(key)=\(value)")
            request.httpBody = data.data(using: .utf8)
        } else {
            request.httpBody = "\(key)=\(value)".data(using: .utf8)
        }
        return self
    }

    func setBody<T: Encodable>(json obj: T) -> JsonContentSetterReturnType {
        do {
            let data = try encoder.encode(obj)
            request.httpBody = data
            return self
        } catch {
            fatalError("Invalid JSON object passed")
        }
    }

    func setBody(raw data: Data) -> RawContentSetterReturnType {
        request.httpBody = data
        return self
    }

    func build() -> URLRequest {
        return request
    }
}

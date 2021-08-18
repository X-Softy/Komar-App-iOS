//
//  APIRequestBuilderFactory.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/17/21.
//

import Foundation

class APIRequestBuilderFactory {
    private let scheme: HTTPSchemeType
    private let host: String

    static let `default`: APIRequestBuilderFactory = .init()

    init(scheme: HTTPSchemeType = Bundle.main.scheme,
         host: String = Bundle.main.host) {
        self.scheme = scheme
        self.host = host
    }

    var requestBuilder: HostSetterReturnType {
        let requestBuilder = HTTPRequestBuilderImpl.createInstance()
        return requestBuilder
            .set(scheme: scheme)
            .set(host: host)
    }
}

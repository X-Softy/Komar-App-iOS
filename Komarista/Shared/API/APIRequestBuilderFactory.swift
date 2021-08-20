//
//  APIRequestBuilderFactory.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/17/21.
//

import Foundation

class APIRequestBuilderFactory {
    private let baseURL: String

    static let `default`: APIRequestBuilderFactory = .init()

    init(baseURL: String = Bundle.main.baseURL) {
        self.baseURL = baseURL
    }

    var requestBuilder: HostSetterReturnType {
        let requestBuilder = HTTPRequestBuilderImpl.createInstance()
        return requestBuilder
            .set(baseURL: baseURL)
    }
}

//
//  CategoryListRepository.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/22/21.
//

import Combine

protocol CategoryListRepository: APIRepository {
    func categories() -> AnyPublisher<[Category], ErrorEntity>
}

struct DefaultCategoryListRepository: CategoryListRepository {
    func categories() -> AnyPublisher<[Category], ErrorEntity> {
        call(with: requestBuilder
                       .set(path: "/categories")
                       .set(method: HTTPMethodGet()))
    }
}

//
//  CategoryListService.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/22/21.
//

import Combine
import SwiftUI

protocol CategoryListService {
    mutating func categories(_ categories: LoadableSubject<[Category]>)
}

struct DefaultCategoryListService: CategoryListService {
    private let categoryListRepository: CategoryListRepository = DefaultCategoryListRepository()
    private var cancelBag = CancelBag()

    mutating func categories(_ categories: LoadableSubject<[Category]>) {
        categories.wrappedValue = .isLoading
        categoryListRepository.categories()
            .sinkToLoadable { categories.wrappedValue = $0 }
            .store(in: &cancelBag)
    }
}

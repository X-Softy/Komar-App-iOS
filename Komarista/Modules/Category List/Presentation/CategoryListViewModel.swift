//
//  CategoryListViewModel.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/22/21.
//

import Combine
import SwiftUI

extension CategoryList {
    class ViewModel: ObservableObject {
        @Published var categories: Loadable<[Category]> = .notRequested
        @Published var error: ErrorEntity? = nil
        private var categoryService: CategoryService = .shared
        private var cancelBag = CancelBag()

        init() {
            categoryService.$categories
                .sink { [weak self] in self?.categories = $0 }
                .store(in: &cancelBag)
        }

        func loadCategoryList() {
            categoryService.loadIfNeeded()
        }
    }
}

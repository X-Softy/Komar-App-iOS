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
        private var categoryListService: CategoryListService = DefaultCategoryListService()

        func loadCategoryList() {
            categoryListService.categories(subject(\.categories))
        }
    }
}

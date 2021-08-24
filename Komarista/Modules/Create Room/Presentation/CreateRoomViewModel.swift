//
//  CreateRoomViewModel.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/23/21.
//

import Combine
import SwiftUI

extension CreateRoom {
    class ViewModel: ObservableObject {
        @Published var title: String = ""
        @Published var description: String = ""
        @Published var disabled: Bool = true
        @Published var selectedCategory: String = ""
        @Published var categories: Loadable<[Category]> = .notRequested
        private var categoryListService: CategoryListService = DefaultCategoryListService()
        private var cancelBag = CancelBag()

        init() {
            Publishers.CombineLatest3($title, $description, $selectedCategory)
                .sink { [weak self] title, description, selectedCategory in
                    self?.disabled = title.isEmpty || description.isEmpty || selectedCategory.isEmpty
                }
                .store(in: &cancelBag)
        }

        func loadCategoryList() {
            categoryListService.categories(loadableSubject(\.categories))
        }

        func createRoom() {
            print("Creating:", selectedCategory, title, description)
        }
    }
}

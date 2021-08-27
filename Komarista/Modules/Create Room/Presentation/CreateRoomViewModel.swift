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
        @Published var created: Loadable<None> = .notRequested
        @Published var error: ErrorEntity? = nil
        private var categoryService: CategoryService = .shared
        private var createRoomService: CreateRoomService = DefaultCreateRoomService()
        private var cancelBag = CancelBag()

        init() {
            Publishers.CombineLatest3($title, $description, $selectedCategory)
                .sink { [weak self] title, description, selectedCategory in
                    self?.disabled = title.isEmpty || description.isEmpty || selectedCategory.isEmpty
                }
                .store(in: &cancelBag)

            categoryService.$categories
                .sink { [weak self] in self?.categories = $0 }
                .store(in: &cancelBag)

            $created
                .sink { [weak self] in self?.handle(created: $0) }
                .store(in: &cancelBag)
        }

        func loadCategoryList() {
            categoryService.loadIfNeeded()
        }

        func createRoom() {
            createRoomService.create(
                room: .init(
                    categoryId: selectedCategory,
                    title: title,
                    description: description
                ),
                subject(\.created)
            )
        }

        private func handle(created: Loadable<None>) {
            switch created {
            case .notRequested:
                break // initial value
            case .isLoading:
                disabled = true
            case .loaded:
                error = .init(message: "create.room.created".localized)
                disabled = false
            case .failed(let cause):
                error = cause
                disabled = false
            }
        }
    }
}

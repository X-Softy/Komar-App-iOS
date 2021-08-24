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
        @Published var created: Loadable<Void> = .notRequested
        @Published var error: ErrorEntity? = nil
        private var categoryListService: CategoryListService = DefaultCategoryListService()
        private var createRoomService: CreateRoomService = DefaultCreateRoomService()
        private var cancelBag = CancelBag()

        init() {
            Publishers.CombineLatest3($title, $description, $selectedCategory)
                .sink { [weak self] title, description, selectedCategory in
                    self?.disabled = title.isEmpty || description.isEmpty || selectedCategory.isEmpty
                }
                .store(in: &cancelBag)

            $created.sink { [weak self] in
                guard let self = self else { return }
                switch $0 {
                case .notRequested: break // initial value
                case .isLoading: break    // TODO: change button to loading state
                case .loaded: self.error = .init(message: "Created")
                case .failed(let error): self.error = error
                }
            }
            .store(in: &cancelBag)
        }

        func loadCategoryList() {
            categoryListService.categories(loadableSubject(\.categories))
        }

        func createRoom() {
            createRoomService.create(
                room: .init(
                    categoryId: selectedCategory,
                    title: title,
                    description: description
                ),
                loadableSubject(\.created)
            )
        }
    }
}

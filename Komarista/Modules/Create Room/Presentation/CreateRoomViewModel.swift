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
        let params: Params
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

        struct Params {
            let onDisappear: (() -> Void)?

            init(onDisappear: (() -> Void)? = nil) {
                self.onDisappear = onDisappear
            }
        }

        init(with params: Params = .init()) {
            self.params = params

            Publishers.CombineLatest3($title, $description, $selectedCategory)
                .sink { [weak self] title, description, selectedCategory in
                    self?.disabled = title.isEmpty || description.isEmpty || selectedCategory.isEmpty
                }
                .store(in: &cancelBag)

            $created
                .sink { [weak self] in self?.handle(created: $0) }
                .store(in: &cancelBag)
        }

        func loadCategoryList() {
            categoryListService.categories(subject(\.categories))
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

        private func handle(created: Loadable<Void>) {
            switch created {
            case .notRequested:
                break // initial value
            case .isLoading:
                disabled = true
            case .loaded:
                error = .init(message: "create.room.created".localized)
                disabled = false
            case .failed(let error):
                self.error = error
                disabled = false
            }
        }
    }
}

//
//  CategoryListService.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/22/21.
//

import Combine
import SwiftUI

class CategoryService: ObservableObject {
    @Published var categories: Loadable<[Category]> = .notRequested
    private var __categories: [Category] = [] {
        willSet { categories = .loaded(newValue) }
    }
    private let categoryListRepository: CategoryListRepository = DefaultCategoryListRepository()
    private let resourceRepository: ResourceRepository = DefaultResourceRepository()
    private var cancelBag = CancelBag()
    static var shared: CategoryService = .init()

    private init() {}

    func loadIfNeeded() {
        switch categories {
        case .notRequested, .failed:
            load()
        case .isLoading, .loaded:
            break
        }
    }

    func category(by id: String) -> Category? {
        __categories.first { $0.id == id }
    }

    private func load() {
        categories = .isLoading
        categoryListRepository.categories()
            .sinkToLoadable { [weak self] in
                guard let self = self else { return }
                if case .loaded(let list) = $0 { // fetch images in case of success
                    self.__categories = list
                    for (index, category) in list.enumerated() {
                        self.resourceRepository.load(image: category.imageId) { result in
                            if case .success(let image) = result {
                                self.__categories[index].image = image
                            }
                        }
                    }
                } else {
                    self.categories = $0
                }
            }
            .store(in: &cancelBag)
    }
}

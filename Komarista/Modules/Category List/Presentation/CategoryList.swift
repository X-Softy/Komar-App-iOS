//
//  CategoryList.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/22/21.
//

import SwiftUI

struct CategoryList: View {
    @ObservedObject private var viewModel: ViewModel = .init()
    @State private var error: ErrorEntity? = nil

    var body: some View {
        Group { content }
            .navigationBarTitle("category.list.bar.title")
            .alert(error: $error)
    }

    private var content: AnyView {
        switch viewModel.categories {
        case .notRequested, .isLoading:
            return AnyView(loadingView)
        case .loaded(let categories):
            return AnyView(list(categories: categories))
        case .failed(let error):
            self.error = error
            return AnyView(errorView)
        }
    }

    private func list(categories: [Category]) -> some View {
        List {
            ForEach(categories) { category in
                NavigationLink(destination: Rooms(viewModel: .init(of: category))) {
                    Text(category.title)
                }
            }
        }
    }

    private var loadingView: some View {
        ActivityIndicatorView()
            .onAppear(perform: viewModel.loadCategoryList)
    }

    private var errorView: some View {
        EmptyView()
    }
}

struct CategoryList_Previews: PreviewProvider {
    static var previews: some View {
        CategoryList()
    }
}

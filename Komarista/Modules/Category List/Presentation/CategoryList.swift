//
//  CategoryList.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/22/21.
//

import SwiftUI

struct CategoryList: View {
    @ObservedObject private var viewModel: ViewModel = .init()

    var body: some View {
        ZStack {
            content(of: viewModel.categories, $viewModel.error) { categories in
                List {
                    ForEach(categories) { category in
                        NavigationLink(destination: Rooms(viewModel: .init(of: category))) {
                            Text(category.title)
                        }
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarTitle("category.list.bar.title")
        .alert(error: $viewModel.error)
        .onAppear(perform: viewModel.loadCategoryList)
    }
}

struct CategoryList_Previews: PreviewProvider {
    static var previews: some View {
        CategoryList()
    }
}

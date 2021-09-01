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
                        ZStack {
                            NavigationLink(destination: Rooms(viewModel: .init(of: category))) { EmptyView() }
                                .frame(width: 0)
                                .opacity(0)
                            VStack(spacing: 0) {
                                Image(uiImage: UIImage(data: category.image ?? Data()) ?? UIImage())
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 128)
                                    .clipped()
                                HStack {
                                    Spacer()
                                        .frame(width: 16)
                                    Text(category.title)
                                        .foregroundColor(.primary)
                                        .font(.safeTitle2)
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 36)
                                .background(Color._primary)
                            }
                            .frame(maxWidth: .infinity)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color._secondary, lineWidth: 1)
                            )
                        }
                    }
                }
                .listStyle(PlainListStyle())
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

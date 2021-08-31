//
//  Home.swift
//  Komarista
//
//  Created by Giorgi Kratsashvili on 8/22/21.
//

import SwiftUI

struct Home: View {
    var body: some View {
        TabView {
            NavigationView { CategoryList() }
                .tabItem {
                    Image("Pages/Home/category.list")
                    Text("home.tab.title.category.list")
                }
            NavigationView { MyRooms() }
                .tabItem {
                    Image("Pages/Home/my.rooms")
                    Text("home.tab.title.my.rooms")
                }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

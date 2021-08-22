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
            CategoryList()
                .tabItem {
                    Image("pages/home/category.list")
                    Text("home.tab.title.category.list")
                }
            MyRooms()
                .tabItem {
                    Image("pages/home/my.rooms")
                    Text("home.tab.title.my.rooms")
                }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

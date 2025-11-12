//
//  TabScreen.swift
//  LinkedIdApp
//
//  Created by David Molano on 2025-11-05.
//

import SwiftUI

struct TabScreen: View {
    var body: some View {
        TabView{
            HomeScreen()
                .tabItem{
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            CreateTweetView()
                .tabItem{
                    Image(systemName: "plus.app.fill")
                    Text("Create Tweet")
                }
            
            SearchUsersView()
                .tabItem{
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            ProfileView()
                .tabItem{
                    Image(systemName: "person.2.fill")
                    Text("Profile")
                }
            
        }
    }
}

#Preview {
    TabScreen()
}

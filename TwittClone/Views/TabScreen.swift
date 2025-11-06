//
//  TabScreen.swift
//  LinkedIdApp
//
//  Created by Jimena Marin on 2025-10-02.
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
            ProfileView()
                .tabItem{
                    Image(systemName: "person.2.fill")
                    Text("Profile")
                }
//            
//            PostView()
//                .tabItem{
//                    Image(systemName: "plus.app.fill")
//                    Text("Post")
//                }
//            
//            NotificationListView(notifications: sampleNotifications)
//                            .tabItem{
//                                Image(systemName: "bell.fill")
//                                Text("Notifications")
//                }
//            JobView()
//                .tabItem{
//                    Image(systemName: "briefcase.fill")
//                    Text("Jobs")
//                }
            
        }
    }
}

#Preview {
    TabScreen()
}

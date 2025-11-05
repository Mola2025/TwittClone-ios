//
//  ContentView.swift
//  TwittClone
//
//  Created by David Molano on 2025-10-30.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        NavigationView {
            if authManager.user != nil {
                //HomeView()
                
            } else {
                //RegisterView()
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView().environmentObject(AuthManager())
}

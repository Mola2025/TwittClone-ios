//
//  ProfileView.swift
//  TwittClone
//
//  Created by David Molano on 2025-11-05.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var authManager: AuthManager
    @State private var errorMessage: String? = nil
    var body: some View {
        Button(role: .destructive){
            singOut()
        }label: {
            Text("Sign Out")
                .frame(maxWidth: 200)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(30)
        }
        .padding()
        
        if let errorMessage = errorMessage {
            Text(errorMessage)
                .foregroundColor(.red)
                .font(.caption)
                .padding()
        }
    }
    private func singOut(){
        authManager.signOut { result in
            switch result{
            case .success():
                self.errorMessage = nil
                print("Successfully Logout")
                
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("Sign Out Error: \(error.localizedDescription)")
            }
        }
    }
}


#Preview {
    ProfileView()
}

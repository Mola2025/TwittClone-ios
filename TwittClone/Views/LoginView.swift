//
//  LoginView.swift
//  AuthFirebaseExample
//
//  Created by David Molano on 2025-10-27.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authManager: AuthManager
    @State private var errorMessage: String? = nil

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 15) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                        
                        Text("Login")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                    }
                    .padding(.top, 100)
                    
                    // Fields
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .foregroundColor(.white)
                                .fontWeight(.medium)
                            
                            TextField("Enter your email", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .foregroundColor(.white)
                                .fontWeight(.medium)
                            
                            SecureField("Enter your password", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }.padding(.horizontal, 20)
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 25)
                    }
                    
                    Button("Login") {
                        login()
                    }
                    .frame(maxWidth: 200)
                    .padding()
                    .background(.white)
                    .foregroundColor(.black)
                    .cornerRadius(15)
                    .fontWeight(.bold)
                    
                    NavigationLink(destination: RegisterView()) {
                        Text("Don't have an account? Register here")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    .padding(.bottom, 40)
                }
            }
        }
    }
    
    private func login(){
        authManager
            .login(email: email, password: password) {
                result in
                switch result {
                case .success(let success):
                    print("User Logged In ")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("\(error.localizedDescription)")
                }
            }
    }
}


#Preview {
    LoginView()
}

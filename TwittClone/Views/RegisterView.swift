//
//  RegisterView.swift
//  TwittClone
//
//  Created by David Molano on 2025-11-05.
//

import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var fullName: String = ""
    @State private var username: String = ""
    @State private var bio: String = ""
    @EnvironmentObject var authManager: AuthManager
    @State private var errorMessage: String? = nil
    
    var body: some View{
        ZStack {
            Color.black.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 15) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                        
                        Text("Create Account")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                    }
                    .padding(.top, 30)
                    
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Full Name")
                                .foregroundColor(.white)
                                .fontWeight(.medium)
                            
                            TextField("Enter your full name", text: $fullName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Username")
                                .foregroundColor(.white)
                                .fontWeight(.medium)
                            
                            TextField("Enter your username", text: $username)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocapitalization(.none)
                        }
                        
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
                    }
                    .padding(.horizontal, 25)
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 25)
                    }
                    
                    Button("Register") {
                        register()
                    }
                    .frame(maxWidth: 200)
                    .padding()
                    .background(.white)
                    .foregroundColor(.black)
                    .cornerRadius(15)
                    .fontWeight(.bold)
                    
                    NavigationLink(destination: LoginView()) {
                        Text("You have an account? Login here")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    .padding(.bottom, 40)
                }
            }
        }
    }
    
    private func register(){
        
        //Validations
        guard !email.isEmpty, !password.isEmpty, !fullName.isEmpty, !username.isEmpty else {
                    errorMessage = "Please fill all required fields"
                    return
                }

        
        guard Validators.isValidEmail(email) else{
            self.errorMessage = "Invalid Email"
            return
        }
        
        guard Validators.isValidPassword(password) else{
            self.errorMessage = "Password must be at least 6 characters"
            return
        }
        
        errorMessage = nil
        
        authManager.registerNewUser(
            email: email,
            password: password,
            fullname: fullName,
            username: username,
            bio: nil, /// Create the user without bio for the start // After can be updated in profile view
            profileImage: nil /// Create the user without profile picture for the start // After can be updated in profile view
        ) { result in
            switch result {
            case .success(let user):
                print("User Registered: \(user.email ?? "No email")")
                // Go to HomeScreen()
                clearForm()
                
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("Registration error: \(error.localizedDescription)")
            }
        }
    }
    
    private func clearForm(){
        email = ""
        password = ""
        fullName = ""
        username = ""
    }
}


#Preview {
    RegisterView().environmentObject(AuthManager())
}

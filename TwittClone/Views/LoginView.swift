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
        VStack {
            TextField("Enter Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)

            SecureField("Enter Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .font(.title3)
            }

            Button("Login") {
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

            //NavigationLink(destination: RegisterView()) {
                //Text("Register, Click here")
            //}
        }
    }
}

#Preview {
    LoginView()
}

//
//  LoginView.swift
//  iHospital
//
//  Created by Adnan Ahmad on 03/07/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var alertTitle: String? = "Invalid Login"
    @State private var alertMessage: String?
    @State private var isLoading: Bool = false
    
    var body: some View {
        NavigationView{
            VStack {
                Spacer()
                
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Welcome back, Sign in to continue")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.top, 1)
                    .padding(.bottom, 20)
                
                Spacer()
                
                VStack(spacing: 16) {
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .paddedTextFieldStyle()
                    
                    
                    SecureField("Password", text: $password)
                        .paddedTextFieldStyle()
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            alertMessage = "Forgot password action not implemented yet"
                        }) {
                            Text("Forgot password?")
                        }
                        .padding(.trailing, 16)
                    }
                }
                .padding()
                
                Spacer()
                
                LoaderButton(isLoading: $isLoading,
                             action: onLogin) {
                    Text("Sign In")
                }
                             .buttonStyle(.borderedProminent)
                             .padding(.horizontal, 16)
                             .padding(.bottom, 20)
                             .foregroundColor(.white)
                
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.gray)
                    
                    NavigationLink(destination: SignUpView()) {
                        Text("Create account")
                    }
                }
            }
            .padding(.bottom, 16)
            .errorAlert(title: $alertTitle, message: $alertMessage)
        }
    }
    
    func onLogin() {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "Please enter email and password."
            return
        }
        
        
        Task {
            isLoading = true
            defer {
                isLoading = false
            }
            
            do {
                let user = try await User.login(email: email, password: password)
                
                if let user {
                    print("User logged in: \(user.email)")
                    User.shared = user
                } else {
                    alertMessage = "Invalid email or password."
                }
            } catch {
                alertMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    LoginView()
}

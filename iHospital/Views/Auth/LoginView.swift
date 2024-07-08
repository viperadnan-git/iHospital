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
    @StateObject private var errorAlertMessage = ErrorAlertMessage(title: "Login Error")
    @State private var isLoading: Bool = false
    
    @EnvironmentObject private var authViewModel: AuthViewModel
    
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
                            errorAlertMessage.message = "Forgot password action not implemented yet"
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
            .errorAlert(errorAlertMessage: errorAlertMessage)
        }
    }
    
    func onLogin() {
        guard !email.isEmpty, !password.isEmpty else {
            errorAlertMessage.message = "Please enter email and password."
            password = ""
            return
        }
        
        
        Task {
            isLoading = true
            defer {
                isLoading = false
            }
            
            do {
                if let user = try await SupaUser.login(email: email, password: password) {
                    print("User logged in: \(user.email)")
                    SupaUser.shared = user
                    try await authViewModel.updateSupaUser()
                } else {
                    errorAlertMessage.message = "Invalid email or password."
                    password = ""
                }
            } catch {
                errorAlertMessage.message = error.localizedDescription
                password = ""
            }
        }
    }
}

#Preview {
    LoginView()
}

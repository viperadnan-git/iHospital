//
//  SignupView.swift
//  iHospital
//
//  Created by Adnan Ahmad on 03/07/24.
//

import SwiftUI

struct SignUpView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var phoneNumber: String = ""
    
    @State private var agreeToTerms: Bool = false
    @State private var errorTitle: String? = "Invalid Input"
    @State private var errorMessage: String?
    @State private var isLoading: Bool = false
    @State private var showVerifyView: Bool = false
    @State private var user: User?
    

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Text("Create account")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("New here? let's start with creating a new account")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.top, 1)
                .padding(.bottom, 20)
            
            VStack(spacing: 16) {
                TextField("Name", text: $name)
                    .paddedTextFieldStyle()
                
                TextField("Email", text: $email)
                    .paddedTextFieldStyle()
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                
                TextField("Phone Number", text: $phoneNumber)
                    .paddedTextFieldStyle()
                    .autocapitalization(.none)
                    .keyboardType(.phonePad)
                    .textContentType(.telephoneNumber)
                
                SecureField("Password", text: $password)
                    .paddedTextFieldStyle()
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .paddedTextFieldStyle()
                
                HStack {
                    Toggle(isOn: $agreeToTerms) {
                        Text("I agree with our ")
                            .font(.subheadline)
                        + Text("Terms and Conditions")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .underline()
                    }
                    .toggleStyle(CheckboxToggleStyle())
                }
                .padding(.horizontal, 16)
            }
            .padding()
           
           
            Spacer()
            
            LoaderButton(isLoading: $isLoading, action: onSignUp) {
                Text("Create account")
            }.buttonStyle(.borderedProminent)
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
                .disabled(!agreeToTerms)
            
            HStack {
                Text("Already have an account?")
                    .foregroundColor(.gray)
                
                Button(action: {
                    // Handle sign in navigation
                }) {
                    Text("Sign In")
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(.bottom, 16)
        .errorAlert(title: $errorTitle, message: $errorMessage)
        .sheet(isPresented: $showVerifyView) {
           
                VerifyView(user: $user)
            
        }
    }
    
    func onSignUp() {
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Please fill all fields."
            return
        }
        
        guard phoneNumber.count == 10 else {
            errorMessage = "Phone number must be exactly 10-digit long"
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }
        
        guard agreeToTerms else {
            errorMessage = "You must agree to the terms and conditions."
            return
        }
        
        
        Task {
            isLoading = true
            defer {
                isLoading = false
            }
            
            do {
                try await User.signUp(email: email, password: password)
                
                let user = User(id: UUID(), name: name, email: email, phoneNumber: 999)
                self.user = user
                self.showVerifyView = true
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    SignUpView()
}

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

    @FocusState private var focusedField: Field?

    @State private var emailError: String?
    @State private var passwordError: String?

    enum Field {
        case email
        case password
    }

    var body: some View {
        NavigationView {
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
                
                VStack(spacing: 4) {
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("Email", text: $email)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .focused($focusedField, equals: .email)
                            .submitLabel(.next)
                            .onSubmit {
                                validateEmail()
                                focusedField = .password
                            }
                            .onChange(of: email) { _ in
                                validateEmail()
                            }
                            .paddedTextFieldStyle()
                            .accessibilityLabel("Email")
                            .accessibilityHint("Enter your email address")
                        
                        if let emailError = emailError {
                            Text(emailError)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.leading, 2)
                                .accessibilityLabel("Email Error")
                                .accessibilityHint(emailError)
                        } else {
                            Spacer().frame(height: 17)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        SecureField("Password", text: $password)
                            .focused($focusedField, equals: .password)
                            .submitLabel(.go)
                            .onSubmit {
                                validatePassword()
                                onLogin()
                            }
                            .onChange(of: password) { _ in
                                validatePassword()
                            }
                            .paddedTextFieldStyle()
                            .accessibilityLabel("Password")
                            .accessibilityHint("Enter your password")
                        
                        if let passwordError = passwordError {
                            Text(passwordError)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.leading, 2)
                                .accessibilityLabel("Password Error")
                                .accessibilityHint(passwordError)
                        } else {
                            Spacer().frame(height: 17)
                        }
                    }

                    HStack {
                        Spacer()
                        Button(action: {
                            errorAlertMessage.message = "Forgot password action not implemented yet"
                            focusedField = nil
                        }) {
                            Text("Forgot password?")
                        }
                        .padding(.trailing, 16)
                        .accessibilityLabel("Forgot password")
                        .accessibilityHint("Tap to reset your password")
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
                .accessibilityLabel("Sign In")
                .accessibilityHint("Tap to sign in")
                
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.gray)
                    
                    NavigationLink(destination: SignUpView()) {
                        Text("Create account")
                    }
                    .accessibilityLabel("Create account")
                    .accessibilityHint("Tap to create a new account")
                }
            }
            .navigationTitle("Login")
            .toolbar(.hidden)
            .padding(.bottom, 16)
            .errorAlert(errorAlertMessage: errorAlertMessage)
        }
    }

    /// Validates the email field
    func validateEmail() {
        if email.isEmpty {
            emailError = "Email is required."
        } else if !email.isEmail {
            emailError = "Please enter a valid email address."
        } else {
            emailError = nil
        }
    }

    /// Validates the password field
    func validatePassword() {
        if password.isEmpty {
            passwordError = "Password is required."
        } else {
            passwordError = nil
        }
    }

    /// Handles the login action
    func onLogin() {
        validateEmail()
        validatePassword()

        guard emailError == nil, passwordError == nil else {
            return
        }

        Task {
            focusedField = nil
            isLoading = true
            defer {
                isLoading = false
            }

            do {
                if let user = try await SupaUser.login(email: email.trimmed.lowercased(), password: password) {
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

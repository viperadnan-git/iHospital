//
//  SignupView.swift
//  iHospital
//
//  Created by Adnan Ahmad on 03/07/24.
//

import SwiftUI

struct SignUpView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var phoneNumber: String = ""
    
    @State private var agreeToTerms: Bool = false
    @State private var isLoading: Bool = false
    @State private var showVerifyView: Bool = false
    @State private var user: SupaUser?
    
    @StateObject private var errorAlertMessage = ErrorAlertMessage(title: "SignUp Error")
    @FocusState private var focusedField: Field?

    @State private var firstNameError: String?
    @State private var lastNameError: String?
    @State private var emailError: String?
    @State private var phoneNumberError: String?
    @State private var passwordError: String?
    @State private var confirmPasswordError: String?

    enum Field {
        case firstName
        case lastName
        case email
        case phoneNumber
        case password
        case confirmPassword
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Spacer()
                
                Text("Create account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("New here? Let's start with creating a new account")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.top, 1)
                    .padding(.bottom, 20)
                
                VStack(spacing: 4) {
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("First Name", text: $firstName)
                            .paddedTextFieldStyle()
                            .focused($focusedField, equals: .firstName)
                            .submitLabel(.next)
                            .onSubmit {
                                validateFirstName()
                                focusedField = .lastName
                            }
                            .onChange(of: firstName) { _ in
                                validateFirstName()
                            }
                            .accessibilityLabel("First Name")
                            .accessibilityHint("Enter your first name")
                        
                        if let firstNameError = firstNameError {
                            Text(firstNameError)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.leading, 2)
                                .accessibilityLabel("First Name Error")
                                .accessibilityHint(firstNameError)
                        } else {
                            Spacer().frame(height: 17)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("Last Name", text: $lastName)
                            .paddedTextFieldStyle()
                            .focused($focusedField, equals: .lastName)
                            .submitLabel(.next)
                            .onSubmit {
                                validateLastName()
                                focusedField = .email
                            }
                            .onChange(of: lastName) { _ in
                                validateLastName()
                            }
                            .accessibilityLabel("Last Name")
                            .accessibilityHint("Enter your last name")
                        
                        if let lastNameError = lastNameError {
                            Text(lastNameError)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.leading, 2)
                                .accessibilityLabel("Last Name Error")
                                .accessibilityHint(lastNameError)
                        } else {
                            Spacer().frame(height: 17)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("Email", text: $email)
                            .paddedTextFieldStyle()
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .focused($focusedField, equals: .email)
                            .submitLabel(.next)
                            .onSubmit {
                                validateEmail()
                                focusedField = .phoneNumber
                            }
                            .onChange(of: email) { _ in
                                validateEmail()
                            }
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
                        TextField("Phone Number", text: $phoneNumber)
                            .paddedTextFieldStyle()
                            .autocapitalization(.none)
                            .keyboardType(.phonePad)
                            .textContentType(.telephoneNumber)
                            .focused($focusedField, equals: .phoneNumber)
                            .submitLabel(.next)
                            .onSubmit {
                                validatePhoneNumber()
                                focusedField = .password
                            }
                            .onChange(of: phoneNumber) { newValue in
                                validatePhoneNumber()
                                if phoneNumber.count > 10 {
                                    phoneNumber = String(phoneNumber.prefix(10))
                                }
                            }
                            .accessibilityLabel("Phone Number")
                            .accessibilityHint("Enter your phone number")
                        
                        if let phoneNumberError = phoneNumberError {
                            Text(phoneNumberError)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.leading, 2)
                                .accessibilityLabel("Phone Number Error")
                                .accessibilityHint(phoneNumberError)
                        } else {
                            Spacer().frame(height: 17)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        SecureField("Password", text: $password)
                            .paddedTextFieldStyle()
                            .focused($focusedField, equals: .password)
                            .submitLabel(.next)
                            .onSubmit {
                                validatePassword()
                                focusedField = .confirmPassword
                            }
                            .onChange(of: password) { _ in
                                validatePassword()
                            }
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
                    
                    VStack(alignment: .leading, spacing: 4) {
                        SecureField("Confirm Password", text: $confirmPassword)
                            .paddedTextFieldStyle()
                            .focused($focusedField, equals: .confirmPassword)
                            .submitLabel(.done)
                            .onSubmit {
                                validateConfirmPassword()
                            }
                            .onChange(of: confirmPassword) { _ in
                                validateConfirmPassword()
                            }
                            .accessibilityLabel("Confirm Password")
                            .accessibilityHint("Re-enter your password")
                        
                        if let confirmPasswordError = confirmPasswordError {
                            Text(confirmPasswordError)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.leading, 2)
                                .accessibilityLabel("Confirm Password Error")
                                .accessibilityHint(confirmPasswordError)
                        } else {
                            Spacer().frame(height: 17)
                        }
                    }
                    
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
                        .accessibilityLabel("Agree to Terms and Conditions")
                        .accessibilityHint("Toggle to agree with our terms and conditions")
                    }
                    .padding(.horizontal, 16)
                }
                
                Spacer()
                
                LoaderButton(isLoading: $isLoading, action: onSignUp) {
                    Text("Create account")
                }
                .buttonStyle(.borderedProminent)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
                .disabled(!agreeToTerms)
                .accessibilityLabel("Create account")
                .accessibilityHint("Tap to create a new account")
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .errorAlert(errorAlertMessage: errorAlertMessage)
            .sheet(isPresented: $showVerifyView) {
                VerifyView(user: $user)
            }
            .onChange(of: isLoading) { newValue in
                if newValue {
                    hideKeyboard()
                }
            }
        }
    }
    
    /// Validates the first name field
    func validateFirstName() {
        if firstName.isEmpty {
            firstNameError = "First name is required."
        } else if !firstName.isAlphabets {
            firstNameError = "First name must contain only alphabets."
        } else if firstName.count >= 25 {
            firstNameError = "First name must be less than 25 characters."
        } else {
            firstNameError = nil
        }
    }

    /// Validates the last name field
    func validateLastName() {
        if lastName.isEmpty {
            lastNameError = "Last name is required."
        } else if !lastName.isAlphabetsAndSpaces {
            lastNameError = "Last name must contain only alphabets and spaces."
        } else if lastName.count >= 25 {
            lastNameError = "Last name must be less than 25 characters."
        } else {
            lastNameError = nil
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

    /// Validates the phone number field
    func validatePhoneNumber() {
        if phoneNumber.isEmpty {
            phoneNumberError = "Phone number is required."
        } else if !phoneNumber.isPhoneNumber {
            phoneNumberError = "Phone number must be exactly 10 digits."
        } else {
            phoneNumberError = nil
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

    /// Validates the confirm password field
    func validateConfirmPassword() {
        if confirmPassword.isEmpty {
            confirmPasswordError = "Confirm password is required."
        } else if confirmPassword != password {
            confirmPasswordError = "Passwords do not match."
        } else {
            confirmPasswordError = nil
        }
    }
    
    /// Handles the sign-up action
    func onSignUp() {
        validateFirstName()
        validateLastName()
        validateEmail()
        validatePhoneNumber()
        validatePassword()
        validateConfirmPassword()

        guard firstNameError == nil, lastNameError == nil, emailError == nil, phoneNumberError == nil, passwordError == nil, confirmPasswordError == nil else {
            return
        }

        Task {
            isLoading = true
            defer {
                isLoading = false
            }
            
            do {
                try await SupaUser.signUp(email: email.trimmed.lowercased(), password: password)
                
                let user = SupaUser(id: UUID(), firstName: firstName.trimmed.capitalized, lastName: lastName.trimmed.capitalized, email: email.trimmed, phoneNumber: Int(phoneNumber)!)
                self.user = user
                self.showVerifyView = true
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
    
    /// Hides the keyboard
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    SignUpView()
}

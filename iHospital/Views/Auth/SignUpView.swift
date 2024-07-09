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
                    HStack {
                        TextField("First Name", text: $firstName)
                            .paddedTextFieldStyle()
                        TextField("Last Name", text: $lastName)
                            .paddedTextFieldStyle()
                    }
                    
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
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                    .disabled(!agreeToTerms)
        }
        .padding(.bottom, 16)
        // back button text 
        .errorAlert(errorAlertMessage: errorAlertMessage)
        .sheet(isPresented: $showVerifyView) {
            VerifyView(user: $user)
        }
    }
    
    func onSignUp() {
        guard !firstName.isEmpty, !lastName.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorAlertMessage.message = "Please fill all fields."
            return
        }
        
        guard firstName.isAlphabets else {
            errorAlertMessage.message = "First name must contain only alphabets."
            return
        }
        
        guard lastName.isAlphabetsAndSpaces else {
            errorAlertMessage.message = "Last name must contain only alphabets and spaces."
            return
        }
        
        guard email.isEmail else {
            errorAlertMessage.message = "Please enter a valid email address."
            return
        }
        
        guard phoneNumber.isPhoneNumber else {
            errorAlertMessage.message = "Phone number must be exactly 10-digit long"
            return
        }
        
        guard agreeToTerms else {
            errorAlertMessage.message = "You must agree to the terms and conditions."
            return
        }
        
        guard let phoneNumber = Int(phoneNumber) else {
            errorAlertMessage.message = "Please enter a valid phone number."
            return
        }
        
        
        Task {
            isLoading = true
            defer {
                isLoading = false
            }
            
            do {
                try await SupaUser.signUp(email: email.trimmed, password: password)
                
                let user = SupaUser(id: UUID(), firstName: firstName.trimmed.capitalized, lastName: lastName.trimmed.capitalized, email: email.trimmed, phoneNumber: phoneNumber)
                self.user = user
                self.showVerifyView = true
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
}

#Preview {
    SignUpView()
}

//
//  UpdatePassword.swift
//  iHospital
//
//  Created by Adnan Ahmad on 09/07/24.
//

import SwiftUI

struct UpdatePassword: View {
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @StateObject private var errorAlertMessage = ErrorAlertMessage()
    
    
    var body: some View {
        VStack {
            Text("Update Password")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Enter your new password")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.top, 1)
                .padding(.bottom, 20)
            
            VStack(spacing: 16) {
                SecureField("New Password", text: $password)
                    .paddedTextFieldStyle()
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .paddedTextFieldStyle()
                
                LoaderButton(isLoading: $isLoading, action: onUpdatePassword) {
                    Text("Update Password")
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .errorAlert(errorAlertMessage: errorAlertMessage)
        }
    }
    
    func onUpdatePassword() {
        guard password == confirmPassword else {
            errorAlertMessage.message = "Passwords do not match"
            return
        }
        
        isLoading = true
        Task {
            do {
                try await SupaUser.updatePassword(password: password)
                errorAlertMessage.title = "Password Updated"
                errorAlertMessage.message = "Your password has been updated successfully"
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
            isLoading = false
        }
    }
}

#Preview {
    UpdatePassword()
}

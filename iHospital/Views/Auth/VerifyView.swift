//
//  VerifyView.swift
//  iHospital
//
//  Created by Adnan Ahmad on 03/07/24.
//

import SwiftUI

struct VerifyView: View {
    @Binding var user: SupaUser?
    @State private var otp: String = ""
    @State private var sendingOtp = true
    @State private var isLoading: Bool = false
    
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    @State private var errorAlertMessage = ErrorAlertMessage(title: "Unable to Verify")
    @FocusState private var focusedField: Field?
    
    enum Field {
        case otp
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Email sent to ")
            + Text("\(user?.email ?? "Unknown")")
                .foregroundColor(.blue)
                .accessibilityLabel("Email sent to \(user?.email ?? "Unknown")")
            
            TextField("Enter OTP", text: $otp)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .paddedTextFieldStyle()
                .multilineTextAlignment(.center)
                .focused($focusedField, equals: .otp)
                .submitLabel(.done)
                .onSubmit {
                    onVerifyOtp()
                }
                .accessibilityLabel("Enter OTP")
                .accessibilityHint("Enter the OTP sent to your email")
            
            LoaderButton(isLoading: $isLoading, action: onVerifyOtp) {
                Text("Verify")
            }
            .buttonStyle(.borderedProminent)
            .accessibilityLabel("Verify")
            .accessibilityHint("Tap to verify OTP")
        
            Button(action: onSendOtp, label: {
                Text("Resend OTP")
            })
            .disabled(sendingOtp)
            .accessibilityLabel("Resend OTP")
            .accessibilityHint("Tap to resend OTP")
        }
        .padding()
        .errorAlert(errorAlertMessage: errorAlertMessage)
        .task {
            enableOtp()
            focusedField = .otp
        }
    }
    
    /// Sends the OTP to the user's email
    func onSendOtp() {
        guard let user = user else { return }
        
        sendingOtp = true
        Task {
            do {
                try await SupaUser.sendOTP(email: user.email)
                enableOtp()
            } catch {
                errorAlertMessage.message = error.localizedDescription
                sendingOtp = false
            }
        }
    }
    
    /// Verifies the OTP entered by the user
    func onVerifyOtp() {
        guard let user = user else { return }
        
        guard otp.trimmed.count == 6 else {
            errorAlertMessage.message = "Please enter a valid 6-digit OTP."
            return
        }
        
        Task {
            isLoading = true
            defer {
                isLoading = false
            }
            
            do {
                let verifiedUser = try await SupaUser.verify(user: user, otp: otp.trimmed)
                if let verifiedUser {
                    print("User verified: \(verifiedUser.email)")
                    SupaUser.shared = verifiedUser
                    try await authViewModel.updateSupaUser()
                } else {
                    errorAlertMessage.message = "Invalid OTP"
                }
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
    
    /// Enables the resend OTP button after a delay
    func enableOtp() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            sendingOtp = false
        }
    }
}

#Preview {
    VerifyView(user: .constant(SupaUser.sample))
}

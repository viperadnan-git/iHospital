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
            
            LoaderButton(isLoading: $isLoading, action: onVerifyOtp) {
                Text("Verify")
            }
            .buttonStyle(.borderedProminent)
        
            Button(action: onSendOtp, label: {
                Text("Resend OTP")
            })
            .disabled(sendingOtp)
        }
        .padding()
        .errorAlert(errorAlertMessage: errorAlertMessage)
        .task {
            enableOtp()
            focusedField = .otp
        }
    }
    
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
    
    func enableOtp() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            sendingOtp = false
        }
    }
}

#Preview {
    return VerifyView(user: .constant(SupaUser.sample))
}

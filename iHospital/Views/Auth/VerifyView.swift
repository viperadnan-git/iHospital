//
//  VerifyView.swift
//  iHospital
//
//  Created by Adnan Ahmad on 03/07/24.
//

import UIKit

import SwiftUI

struct VerifyView: View {
    @Binding var user: SupaUser?
    @State private var otp: String = ""
    @State private var sendingOtp = true
    @State private var isLoading: Bool = false
    
    @State private var errorAlertMessage = ErrorAlertMessage(title: "Unable to Verify")
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Email sent to ")
                .font(.caption)
            + Text("\(user?.email ?? "Unknown")")
                .font(.caption)
                .foregroundStyle(Color.blue)
            TextField("Enter OTP", text: $otp)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .paddedTextFieldStyle()
                .multilineTextAlignment(.center)
            
            LoaderButton(isLoading: $isLoading, action: onVerifyOtp) {
                Text("Verify")
            }
            .buttonStyle(.borderedProminent)
        
            
            
            Button(action: onSendOtp, label: {
                Text("Resend OTP")
            }
            )
            .disabled(sendingOtp)
        }
        .padding()
        .errorAlert(errorAlertMessage: errorAlertMessage)
        .task {
           enableOtp()
        }
    }
    
    func onSendOtp() {
        guard let user = user else {return}
        
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
        guard let user = user else {return}
        
        guard otp.count == 6 else {
            errorAlertMessage.message = "Please enter a valid 6-digit OTP."
            return
        }
        
        
        Task {
            isLoading = true
            defer {
                isLoading = false
            }
            
            do {
                let user = try await SupaUser.verify(user: user, otp: otp)
                if let user {
                    print("User verified: \(user.email)")
                    SupaUser.shared = user
                } else {
                    errorAlertMessage.message = "Invalid OTP."
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
    @State var user:SupaUser? = SupaUser(id: UUID(), name: "Adnan", email: "adnan@mail.viperadnan.com", phoneNumber: 999)
    return VerifyView(user: $user)
}

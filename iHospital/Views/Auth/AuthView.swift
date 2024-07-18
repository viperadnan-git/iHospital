//
//  AuthView.swift
//  iHospital
//
//  Created by Adnan Ahmad on 03/07/24.
//

import SwiftUI

struct AuthView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                // Sign Up Navigation Link
                NavigationLink(destination: SignUpView()) {
                    Text("Sign Up")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .accessibilityLabel("Sign Up")
                        .accessibilityHint("Navigates to the sign-up screen")
                }
                
                // Sign In Navigation Link
                NavigationLink(destination: LoginView()) {
                    Text("Sign In")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .accessibilityLabel("Sign In")
                        .accessibilityHint("Navigates to the sign-in screen")
                }
                
                Spacer()
            }
            .navigationTitle("Welcome")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AuthView()
}

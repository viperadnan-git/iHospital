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
                   NavigationLink(destination: SignUpView()) {
                       Text("Sign Up")
                           .font(.title)
                           .foregroundColor(.white)
                           .padding()
                           
                           .background(Color.blue)
                           .cornerRadius(10)
                           .padding(.horizontal)
                   }
                   NavigationLink(destination: LoginView()) {
                       Text("Sign In")
                           .font(.title)
                           .foregroundColor(.white)
                           .padding()
                           
                           .background(Color.blue)
                           .cornerRadius(10)
                           .padding(.horizontal)
                   }
                   Spacer()
               }
           }
       }
}

#Preview {
    AuthView()
}

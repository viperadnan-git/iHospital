//
//  iHospitalApp.swift
//  iHospital
//
//  Created by Adnan Ahmad on 03/07/24.
//

import SwiftUI

@main
struct iHospitalApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authViewModel.user != nil {
                    MainView()
                } else {
                    LoginView()
                }
            }.environmentObject(authViewModel)
        }
    }
}

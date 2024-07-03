//
//  iHospitalApp.swift
//  iHospital
//
//  Created by Adnan Ahmad on 03/07/24.
//

import SwiftUI

@main
struct iHospitalApp: App {
    @State private var isAuthenticated = User.shared != nil
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isAuthenticated {
                    MainView()
                } else {
                    AuthView()
                }
            }
            .task {
                for await state in supabase.auth.authStateChanges {
                    if [.initialSession, .signedIn, .signedOut].contains(state.event) {
                        isAuthenticated = state.session != nil
                    }
                }
            }
        }
    }
}

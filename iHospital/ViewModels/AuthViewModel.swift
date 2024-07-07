//
//  AuthViewModel.swift
//  iHospital
//
//  Created by Adnan Ahmad on 07/07/24.
//

import SwiftUI
import Supabase

class AuthViewModel: ObservableObject {
    @Published var user: SupaUser? = SupaUser.shared
    
    @MainActor
    init() {
        Task {
            // TODO: optimize this, this check for user login at startup
            for await state in supabase.auth.authStateChanges {
                if [.initialSession, .signedOut].contains(state.event) {
                    try? await updateSupaUser()
                }
            }
        }
    }
    
    @MainActor
    func updateSupaUser() async throws {
        let user = try await SupaUser.getSupaUser()
        SupaUser.shared = user
        self.user = user
    }
}

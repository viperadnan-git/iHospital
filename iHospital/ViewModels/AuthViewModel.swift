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
            await observeAuthStateChanges()
        }
    }
    
    /// Observes authentication state changes and updates the user accordingly
    @MainActor
    func observeAuthStateChanges() async {
        for await state in supabase.auth.authStateChanges {
            if [.initialSession, .signedOut].contains(state.event) {
                try? await updateSupaUser()
            }
        }
    }

    /// Updates the SupaUser instance and sets the shared user
    @MainActor
    func updateSupaUser() async throws {
        let user = try await SupaUser.getSupaUser()
        SupaUser.shared = user
        self.user = user
    }
}

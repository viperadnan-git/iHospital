//
//  Supabase.swift
//  iHospital
//
//  Created by Adnan Ahmad on 03/07/24.
//


import Foundation
import SwiftUI
import Supabase
import Auth

let supabase = SupabaseClient(
    supabaseURL: URL(string: SUPABASE_URL)!,
    supabaseKey: SUPABASE_KEY
)

enum SupabaseTable: String {
    case users = "users"
}

class SupabaseManager: ObservableObject {
    static let shared = SupabaseManager()
    
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    
    func handleSupabaseError(_ error: Error) {
        if let authError = error as? Auth.AuthError {
            self.errorMessage = authError.localizedDescription
        } else if let postgrestError = error as? PostgrestError {
            self.errorMessage = postgrestError.localizedDescription
        } else {
            self.errorMessage = error.localizedDescription
            print(error)
        }
        
        self.showErrorAlert = true
    }
}

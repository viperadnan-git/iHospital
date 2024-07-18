//
//  SupaUser.swift
//  iHospital
//
//  Created by Adnan Ahmad on 03/07/24.
//

import Foundation
import Auth
import Supabase

struct SupaUser: Codable, Hashable {
    let id: UUID
    let firstName: String
    let lastName: String
    var email: String {
        didSet {
            email = email.lowercased()
        }
    }
    let phoneNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phoneNumber = "phone_number"
    }
    
    var name: String {
        "\(firstName) \(lastName)"
    }
    
    static var shared: SupaUser? = loadUser() {
        didSet {
            shared?.saveUser()
        }
    }
    
    static let sample: SupaUser = SupaUser(id: UUID(), firstName: "John", lastName: "Doe", email: "mail@viperadnan.com", phoneNumber: 1234567890)
    
    /// Saves the user object to UserDefaults
    func saveUser() {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self) else {
            print("Failed to encode object of type \(self.self)")
            return
        }
        
        UserDefaults.standard.set(data, forKey: Constants.supabaseKey)
        print("User saved to user defaults")
    }
    
    /// Loads the user object from UserDefaults
    static let loadUser: () -> SupaUser? = {
        guard let data = UserDefaults.standard.data(forKey: Constants.supabaseKey) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        guard let user = try? decoder.decode(SupaUser.self, from: data) else {
            print("Failed to decode user from user defaults")
            return nil
        }
        
        return user
    }
    
    /// Signs up a new user with email and password
    /// - Parameters:
    ///   - email: The user's email
    ///   - password: The user's password
    static func signUp(email: String, password: String) async throws {
        try await supabase.auth.signUp(email: email, password: password)
    }
    
    /// Sends an OTP to the user's email
    /// - Parameter email: The user's email
    static func sendOTP(email: String) async throws {
        try await supabase.auth.signInWithOTP(email: email)
    }
    
    /// Verifies the user with an OTP and saves the user
    /// - Parameters:
    ///   - user: The user to verify
    ///   - otp: The OTP code
    /// - Returns: The verified user or an existing user if already verified
    static func verify(user: SupaUser, otp: String) async throws -> SupaUser? {
        let session = try await supabase.auth.verifyOTP(email: user.email, token: otp, type: .email)
        let userToSave = SupaUser(
            id: session.user.id,
            firstName: user.firstName,
            lastName: user.lastName,
            email: user.email,
            phoneNumber: user.phoneNumber
        )
        
        do {
            let user: SupaUser = try await supabase.from(SupabaseTable.users.id).insert(userToSave).select().single().execute().value
            return user
        } catch {
            if let error = error as? PostgrestError, error.code == "23505" {
                // If the user already exists, return the user
                return userToSave
            }
            throw error
        }
    }
    
    /// Logs in a user with email and password
    /// - Parameters:
    ///   - email: The user's email
    ///   - password: The user's password
    /// - Returns: The logged-in user if email is confirmed
    static func login(email: String, password: String) async throws -> SupaUser? {
        let session = try await supabase.auth.signIn(email: email, password: password)
        if session.user.emailConfirmedAt != nil {
            return try await SupaUser.getSupaUser()
        }
        return nil
    }
    
    /// Logs out the current user
    static func logOut() async throws {
        UserDefaults.standard.removeObject(forKey: Constants.supabaseKey)
        try await supabase.auth.signOut()
    }
    
    /// Gets the current SupaUser object
    /// - Returns: The current user if authenticated
    static func getSupaUser() async throws -> SupaUser? {
        guard let user = supabase.auth.currentUser else {
            return nil
        }
        
        let supaUser: SupaUser = try await supabase.from(SupabaseTable.users.id).select().eq("user_id", value: user.id).single().execute().value
        return supaUser
    }
    
    /// Updates the user's password
    /// - Parameter password: The new password
    static func updatePassword(password: String) async throws {
        try await supabase.auth.update(user: UserAttributes(password: password))
    }
    
    /// Fetches the invoices for the current user
    /// - Returns: An array of invoices
    func fetchInvoices() async throws -> [Invoice] {
        let response: [Invoice] = try await supabase.from(SupabaseTable.invoices.id)
            .select(Invoice.supabaseSelectQuery)
            .eq("user_id", value: id.uuidString)
            .order("created_at", ascending: false)
            .execute()
            .value
        
        return response
    }
}

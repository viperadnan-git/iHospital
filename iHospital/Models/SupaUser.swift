//
//  User.swift
//  iHospital
//
//  Created by Adnan Ahmad on 03/07/24.
//

import Foundation
import Auth
import Supabase


struct SupaUser: Codable {
    let id: UUID
    let name: String
    var email: String {
        didSet {
            email = email.lowercased()
        }
    }
    let phoneNumber: Int
    var firstName: Substring {
        name.split(separator: " ").first!
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case name
        case email
        case phoneNumber = "phone_number"
    }
    
    static var shared: SupaUser? = loadUser() {
        didSet {
            if let shared = shared {
                shared.saveUser()
            }
        }
    }
    
    func saveUser() {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self) else {
            print("Failed to encode object of type \(self.self)")
            return
        }
        
        UserDefaults.standard.set(data, forKey: USER_INFO_KEY)
        print("User saved to user defaults")
    }
    
    static let loadUser: () -> SupaUser? = {
        guard let data = UserDefaults.standard.data(forKey: USER_INFO_KEY) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        guard let user = try? decoder.decode(SupaUser.self, from: data) else {
            print("Failed to decode user from user defaults")
            return nil
        }
        
        return user
        
    }
    
    static func signUp(email: String, password:String) async throws {
        try await supabase.auth.signUp(email: email, password: password)
    }
    
    static func sendOTP(email: String) async throws {
        try await supabase.auth.signInWithOTP(email: email)
    }
    
    static func verify(user: SupaUser, otp: String) async throws -> SupaUser? {
        let session = try await supabase.auth.verifyOTP(email: user.email, token: otp, type: .email)
        let userToSave = SupaUser(
            id: session.user.id,
            name: user.name,
            email: user.email,
            phoneNumber: user.phoneNumber
        )
        
        do {
            let user:SupaUser = try await supabase.from(SupabaseTable.users.id).insert(userToSave).select().single().execute().value
            return user
        } catch {
            if let error = error as? PostgrestError {
                // If the user already exists, return the user
                if error.code == "23505" {
                    return userToSave
                }
            }
            throw error
        }
    }
    
    static func login(email: String, password: String) async throws -> SupaUser? {
        let session = try await supabase.auth.signIn(email: email, password: password)
        if session.user.emailConfirmedAt != nil {
            return try await SupaUser.getSupaUser()
        }
        
        return nil
    }
    
    static func logOut() async throws {
        UserDefaults.standard.removeObject(forKey: USER_INFO_KEY)
        try await supabase.auth.signOut()
    }
    
    
    static func getSupaUser() async throws -> SupaUser? {
        guard let user = supabase.auth.currentUser else {
            return nil
        }
        
        let supaUser:SupaUser = try await supabase.from(SupabaseTable.users.id).select().eq("user_id", value: user.id).single().execute().value
        return supaUser
    }
}

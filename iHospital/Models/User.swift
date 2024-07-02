//
//  User.swift
//  iHospital
//
//  Created by Adnan Ahmad on 01/07/24.
//


import Foundation
import Auth
import Supabase


struct User: Codable {
    let id: UUID
    let name: String
    var email: String {
        didSet {
            email = email.lowercased()
        }
    }
    let dateOfBirth: Date
    let gender: Gender
    let phoneNumber: Int

    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case name
        case email
        case dateOfBirth = "date_of_birth"
        case gender
        case phoneNumber = "phone_number"
    }
    
    static var shared: User? = loadUser() {
        didSet {
            shared?.saveUser()
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
    
    static let loadUser: () -> User? = {
        guard let data = UserDefaults.standard.data(forKey: USER_INFO_KEY) else {
            return nil
        }
        
        guard let user = try? User.decoder.decode(User.self, from: data) else {
            print("Failed to decode user from user defaults")
            return nil
        }
        
        return user
        
    }
    
    static func signUp(email: String, password:String) async throws {
        do {
            try await supabase.auth.signUp(email: email, password: password)
        } catch {
            throw error
        }
    }
    
    static func sendOTP(email: String) async throws {
        do {
            try await supabase.auth.signInWithOTP(email: email)
        } catch {
            throw error
        }
    }
    
    static func verify(user: User, otp: String) async throws -> User? {
        do {
            let session = try await supabase.auth.verifyOTP(email: user.email, token: otp, type: .email)
            let userToSave = User(
                id: session.user.id,
                name: user.name,
                email: user.email,
                dateOfBirth: user.dateOfBirth,
                gender: user.gender,
                phoneNumber: user.phoneNumber
            )
            
            do {
                let user:User = try await supabase.from(SupabaseTable.users.rawValue).insert(userToSave).select().single().execute().value
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
        } catch {
            throw error
        }
    }
    
    static func login(email: String, password: String) async throws -> User? {
        do {
            let session = try await supabase.auth.signIn(email: email, password: password)
            
            print(session.user)

            if session.user.emailConfirmedAt != nil{
                return try await User.fromSupabaseUser(user: session.user)
            }
            
            return nil
        } catch {
            throw error
        }
    }
    
    static func logOut() async throws {
        do {
            UserDefaults.standard.removeObject(forKey: USER_INFO_KEY)
            try await supabase.auth.signOut()
        } catch {
            throw error
        }
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(User.dateFormatter)
        return decoder
    }()
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.email = try container.decode(String.self, forKey: .email)
        
        let dateOfBirthString = try container.decode(String.self, forKey: .dateOfBirth)
        
        if let dateOfBirth = User.dateFormatter.date(from: dateOfBirthString) {
            self.dateOfBirth = dateOfBirth.localDate()
        } else {
            throw DecodingError.dataCorruptedError(forKey: .dateOfBirth, in: container, debugDescription: "Invalid date format: \(dateOfBirthString)")
        }
        
        self.gender = try container.decode(Gender.self, forKey: .gender)
        self.phoneNumber = try container.decode(Int.self, forKey: .phoneNumber)
    }
    
    
    static func fromSupabaseUser(user: Auth.User) async throws -> User? {
        do {
            let user:User = try await supabase.from(SupabaseTable.users.rawValue).select().eq("user_id", value: user.id).single().execute().value
            
            return user
        } catch {
            throw error
        }
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(User.dateFormatter.string(from: dateOfBirth), forKey: .dateOfBirth)
        try container.encode(gender, forKey: .gender)
        try container.encode(phoneNumber, forKey: .phoneNumber)
    }
    
    init(id: UUID, name: String, email: String, dateOfBirth: Date, gender: Gender, phoneNumber: Int) {
        self.id = id
        self.name = name
        self.email = email
        self.dateOfBirth = dateOfBirth
        self.gender = gender
        self.phoneNumber = phoneNumber
    }
}

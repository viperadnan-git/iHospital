//
//  Doctor.swift
//  iHospital
//
//  Created by Adnan Ahmad on 05/07/24.
//

import Foundation
import Supabase

struct Doctor: Codable {
    let userId: UUID
    let name: String
    let dateOfBirth: Date
    let gender: Gender
    let phoneNumber: Int
    let email: String
    let qualification: String
    let experienceSince: Date
    let dateOfJoining: Date
    let departmentId: UUID
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case name
        case dateOfBirth = "date_of_birth"
        case gender
        case phoneNumber = "phone_number"
        case email
        case qualification
        case experienceSince = "experience_since"
        case dateOfJoining = "date_of_joining"
        case departmentId = "department_id"
    }
    
    static func fetchAll() async throws -> [Doctor] {
        let response: [Doctor] = try await supabase.from(SupabaseTable.doctors.rawValue)
            .select()
            .execute()
            .value
        
        return response
    }
    
    static var decoder = {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
    
    static var encoder = {
        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        return encoder
    }()
    
    static func fetchDepartmentWise(departmentId: UUID) async throws -> [Doctor] {
        let response = try await supabase.from(SupabaseTable.doctors.rawValue)
            .select()
            .eq("department_id", value: departmentId)
            .execute()
        
        return try decoder.decode([Doctor].self, from: response.data)
    }
}


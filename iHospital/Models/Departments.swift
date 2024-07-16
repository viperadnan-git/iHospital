//
//  Departments.swift
//  iHospital
//
//  Created by Adnan Ahmad on 06/07/24.
//

import Foundation

struct Department: Decodable, Hashable, Identifiable {
    let id: UUID
    let name: String
    let phoneNumber: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case phoneNumber = "phone_number"
    }
    
    static var all: [Department]?
    
    static let defaultDepartment = Department(id: UUID(uuidString: "d7c19d90-d37c-40b5-9437-98491e295f00")!, name: "General Physicians", phoneNumber: nil)
    
    static func fetchAll() async throws -> [Department] {
        if let all = all {
            return all
        }
        
        let departments: [Department] = try await supabase.from(SupabaseTable.departments.id).select().execute().value
        all = departments.sorted { lhs, rhs in
            if lhs.name == "General Physicians" {
                return true
            } else if rhs.name == "General Physicians" {
                return false
            } else {
                return lhs.name < rhs.name
            }
        }
        
        return all!
    }
}

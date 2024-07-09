//
//  Search.swift
//  iHospital
//
//  Created by Adnan Ahmad on 06/07/24.
//

import Foundation

enum SearchType {
    case doctor
    case department
}

enum SearchItem {
    case doctor(Doctor)
    case department(Department)
}

struct Search: Identifiable {
    let name: String
    let type: SearchType
    let id: UUID
    let item: SearchItem
    
    var icon: String {
        switch type {
        case .doctor:
            return "stethoscope"
        case .department:
            return "building.2.crop.circle"
        }
    }
    
    static func doctorsOrDepartments(byName name: String) async throws -> [Search] {
        let searchWords = name.split(separator: " ").map { String($0 + ":*") }
        let searchQuery = searchWords.joined(separator: " | ")
        
        async let doctorsResponse = supabase.from(SupabaseTable.doctors.id)
            .select("*, doctor_settings(*)")
            .textSearch("search_doctor_names", query: searchQuery)
            .execute()
        
        async let departmentsResponse = supabase.from(SupabaseTable.departments.id)
            .select()
            .textSearch("name", query: searchQuery)
            .execute()
        
        let (doctorsData, departmentsData) = try await (doctorsResponse, departmentsResponse)
        
        let doctors = try JSONDecoder().decode([Doctor].self, from: doctorsData.data)
        let departments = try JSONDecoder().decode([Department].self, from: departmentsData.data)
        
        let doctorsSearch = doctors.map { Search(name: $0.name, type: .doctor, id: $0.userId, item: .doctor($0)) }
        let departmentsSearch = departments.map { Search(name: $0.name, type: .department, id: $0.id, item: .department($0)) }
        
        return departmentsSearch + doctorsSearch
    }
}

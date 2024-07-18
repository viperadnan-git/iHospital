//
//  LabTestType.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 16/07/24.
//

import Foundation

class LabTestType: Codable {
    let id: Int
    var name: String
    var price: Int
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case price
        case description
    }
    
    /// Initializes a new LabTestType object
    init(id: Int, name: String, price: Int, description: String) {
        self.id = id
        self.name = name
        self.price = price
        self.description = description
    }
    
    static let supabaseSelectQuery = "*"
    
    static let sample = LabTestType(id: 1, name: "X-Ray", price: 100, description: "X-Ray of the chest")
    
    static var all: [LabTestType] = []
    
    /// Fetches all lab test types from the database
    /// - Parameter force: A flag to force fetch even if cached data exists
    /// - Returns: An array of lab test types
    static func fetchAll(force: Bool = false) async throws -> [LabTestType] {
        if !force, !all.isEmpty {
            return all
        }
        
        let response: [LabTestType] = try await supabase.from(SupabaseTable.labTestTypes.id).select(supabaseSelectQuery).execute().value
        all = response
        return response
    }
    
    /// Creates a new lab test type in the database
    /// - Parameters:
    ///   - name: The name of the lab test type
    ///   - price: The price of the lab test type
    ///   - description: The description of the lab test type
    /// - Returns: The newly created lab test type
    static func new(name: String, price: Int, description: String) async throws -> LabTestType {
        let response: LabTestType = try await supabase.from(SupabaseTable.labTestTypes.id)
            .insert([
                CodingKeys.name.rawValue: name,
                CodingKeys.price.rawValue: String(price),
                CodingKeys.description.rawValue: description
            ])
            .single()
            .execute()
            .value
        
        all.append(response)
        
        return response
    }
    
    /// Saves the current lab test type to the database
    /// - Returns: The updated lab test type
    func save() async throws -> LabTestType {
        let response: LabTestType = try await supabase.from(SupabaseTable.labTestTypes.id)
            .update([
                CodingKeys.name.rawValue: name,
                CodingKeys.price.rawValue: String(price),
                CodingKeys.description.rawValue: description
            ])
            .eq(CodingKeys.id.rawValue, value: id)
            .single()
            .execute()
            .value
        
        if let index = LabTestType.all.firstIndex(where: { $0.id == id }) {
            LabTestType.all[index] = response
        }
        
        return response
    }
    
    /// Deletes the current lab test type from the database
    func delete() async throws {
        try await supabase.from(SupabaseTable.labTestTypes.id)
            .delete()
            .eq(CodingKeys.id.rawValue, value: id)
            .execute()
        
        if let index = LabTestType.all.firstIndex(where: { $0.id == id }) {
            LabTestType.all.remove(at: index)
        }
    }
}

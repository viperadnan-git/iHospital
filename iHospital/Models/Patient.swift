//
//  Patient.swift
//  iHospital
//
//  Created by Adnan Ahmad on 05/07/24.
//

import Foundation


class Patient: Codable, Hashable {
    let id: UUID
    let userId: UUID
    var firstName: String
    var lastName: String
    var gender: Gender
    var phoneNumber: Int
    var bloodGroup: BloodGroup
    var dateOfBirth: Date
    var height: Double?
    var weight: Double?
    var address: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case gender
        case phoneNumber = "phone_number"
        case bloodGroup = "blood_group"
        case dateOfBirth = "date_of_birth"
        case height
        case weight
        case address
    }
    
    var name: String {
        "\(firstName) \(lastName)"
    }
    
    static func == (lhs: Patient, rhs: Patient) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static let decoder = JSONDecoder()
    static let encoder = JSONEncoder()
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        userId = try container.decode(UUID.self, forKey: .userId)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        gender = try container.decode(Gender.self, forKey: .gender)
        phoneNumber = try container.decode(Int.self, forKey: .phoneNumber)
        bloodGroup = try container.decode(BloodGroup.self, forKey: .bloodGroup)
        
        let dateString = try container.decode(String.self, forKey: .dateOfBirth)
        guard let date = Date.dateFormatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .dateOfBirth, in: container, debugDescription: "Invalid date format")
        }
        dateOfBirth = date
        
        height = try container.decodeIfPresent(Double.self, forKey: .height)
        weight = try container.decodeIfPresent(Double.self, forKey: .weight)
        address = try container.decode(String.self, forKey: .address)
    }
    
    init(id: UUID, userId: UUID, firstName: String, lastName: String, gender:Gender, phoneNumber: Int, bloodGroup: BloodGroup, dateOfBirth: Date, height: Double?, weight: Double?, address: String) {
        self.id = id
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.phoneNumber = phoneNumber
        self.bloodGroup = bloodGroup
        self.dateOfBirth = dateOfBirth
        self.height = height
        self.weight = weight
        self.address = address
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(gender, forKey: .gender)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(bloodGroup, forKey: .bloodGroup)
        try container.encode(Date.dateFormatter.string(from: dateOfBirth), forKey: .dateOfBirth)
        try container.encodeIfPresent(height, forKey: .height)
        try container.encodeIfPresent(weight, forKey: .weight)
        try container.encode(address, forKey: .address)
    }
    
    static let sample = Patient(id: UUID(),
                                userId: UUID(),
                                firstName: "John",
                                lastName: "Doe",
                                gender: .male,
                                phoneNumber: 1234567890,
                                bloodGroup: .APositive,
                                dateOfBirth: Date(),
                                height: 5.8,
                                weight: 70,
                                address: "123, Main Street, City, Country")
    
    
    static func addPatient(forUser userId: UUID, firstName: String, lastName: String, gender: Gender, phoneNumber: Int, bloodGroup: BloodGroup, dateOfBirth: Date, height: Double?, weight: Double?, address: String) async throws -> Patient {
        var dataToInsert: [String: String] = [
            "user_id": userId.uuidString,
            "first_name": firstName,
            "last_name": lastName,
            "gender": gender.id,
            "phone_number": String(phoneNumber),
            "blood_group": bloodGroup.rawValue,
            "date_of_birth": Date.dateFormatter.string(from: dateOfBirth),
            "address": address
        ]
        
        if let height = height {
            dataToInsert["height"] = String(height)
        }
        
        if let weight = weight {
            dataToInsert["weight"] = String(weight)
        }
        
        let response = try await supabase.from(SupabaseTable.patients.id)
            .insert(dataToInsert)
            .select()
            .single()
            .execute()
        
        let patient = try decoder.decode(Patient.self, from: response.data)
        return patient
    }
    
    static func fetchAll() async throws -> [Patient] {
        guard let user = SupaUser.shared else { return [] }
        
        let response = try await supabase.from(SupabaseTable.patients.id)
            .select()
            .eq("user_id", value: user.id.uuidString)
            .execute()
        
        let patients = try decoder.decode([Patient].self, from: response.data)
        return patients
    }
    
    func save() async throws {
        var dataToUpdate: [String: String] = [
            "first_name": firstName,
            "last_name": lastName,
            "gender": gender.id,
            "phone_number": String(phoneNumber),
            "blood_group": bloodGroup.rawValue,
            "date_of_birth": Date.dateFormatter.string(from: dateOfBirth),
            "address": address
        ]
        
        if let height = height {
            dataToUpdate["height"] = String(height)
        }
        
        if let weight = weight {
            dataToUpdate["weight"] = String(weight)
        }
        
        try await supabase.from(SupabaseTable.patients.id)
            .update(dataToUpdate)
            .eq("id", value: id.uuidString)
            .select()
            .single()
            .execute()
            .value
    }
}

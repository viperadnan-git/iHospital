//
//  Patient.swift
//  iHospital
//
//  Created by Adnan Ahmad on 05/07/24.
//

import Foundation

class Patient: Codable, Hashable, Identifiable {
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
    
    /// Decodes a Patient object from JSON
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
        guard let date = DateFormatter.dateFormatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .dateOfBirth, in: container, debugDescription: "Invalid date format")
        }
        dateOfBirth = date
        
        height = try container.decodeIfPresent(Double.self, forKey: .height)
        weight = try container.decodeIfPresent(Double.self, forKey: .weight)
        address = try container.decode(String.self, forKey: .address)
    }
    
    /// Initializes a new Patient object
    init(id: UUID, userId: UUID, firstName: String, lastName: String, gender: Gender, phoneNumber: Int, bloodGroup: BloodGroup, dateOfBirth: Date, height: Double?, weight: Double?, address: String) {
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
    
    /// Encodes a Patient object to JSON
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(gender, forKey: .gender)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(bloodGroup, forKey: .bloodGroup)
        try container.encode(DateFormatter.dateFormatter.string(from: dateOfBirth), forKey: .dateOfBirth)
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
    
    /// Adds a new patient for a given user
    /// - Parameters:
    ///   - userId: The UUID of the user
    ///   - firstName: The first name of the patient
    ///   - lastName: The last name of the patient
    ///   - gender: The gender of the patient
    ///   - phoneNumber: The phone number of the patient
    ///   - bloodGroup: The blood group of the patient
    ///   - dateOfBirth: The date of birth of the patient
    ///   - height: The height of the patient
    ///   - weight: The weight of the patient
    ///   - address: The address of the patient
    /// - Returns: The newly added patient
    static func addPatient(forUser userId: UUID, firstName: String, lastName: String, gender: Gender, phoneNumber: Int, bloodGroup: BloodGroup, dateOfBirth: Date, height: Double?, weight: Double?, address: String) async throws -> Patient {
        var dataToInsert: [String: String] = [
            "user_id": userId.uuidString,
            "first_name": firstName,
            "last_name": lastName,
            "gender": gender.id,
            "phone_number": String(phoneNumber),
            "blood_group": bloodGroup.rawValue,
            "date_of_birth": DateFormatter.dateFormatter.string(from: dateOfBirth),
            "address": address
        ]
        
        if let height = height {
            dataToInsert["height"] = String(height)
        }
        
        if let weight = weight {
            dataToInsert["weight"] = String(weight)
        }
        
        let response: Patient = try await supabase.from(SupabaseTable.patients.id)
            .insert(dataToInsert)
            .select()
            .single()
            .execute()
            .value
        
        return response
    }
    
    /// Fetches all patients for the current user
    /// - Returns: An array of patients
    static func fetchAll() async throws -> [Patient] {
        guard let user = SupaUser.shared else { return [] }
        
        let response: [Patient] = try await supabase.from(SupabaseTable.patients.id)
            .select()
            .eq("user_id", value: user.id.uuidString)
            .execute()
            .value
        
        return response
    }
    
    /// Saves the current patient object
    func save() async throws {
        var dataToUpdate: [String: String] = [
            "first_name": firstName,
            "last_name": lastName,
            "gender": gender.id,
            "phone_number": String(phoneNumber),
            "blood_group": bloodGroup.rawValue,
            "date_of_birth": DateFormatter.dateFormatter.string(from: dateOfBirth),
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
    
    /// Fetches the medical records for the patient
    /// - Returns: An array of medical records
    func fetchMedicalRecords() async throws -> [MedicalRecord] {
        let response: [MedicalRecord] = try await supabase.from(SupabaseTable.medicalRecords.id)
            .select(MedicalRecord.supabaseSelectQuery)
            .eq("patient_id", value: id.uuidString)
            .order("created_at", ascending: false)
            .execute()
            .value
        
        return response
    }
    
    /// Fetches the lab tests for the patient
    /// - Returns: An array of lab tests
    func fetchLabTests() async throws -> [LabTest] {
        let response: [LabTest] = try await supabase.from(SupabaseTable.labTests.id)
            .select(LabTest.supabaseSelectQuery)
            .eq("patient_id", value: id.uuidString)
            .order("created_at", ascending: false)
            .execute()
            .value
        
        return response
    }
}

//
//  Doctor.swift
//  iHospital
//
//  Created by Adnan Ahmad on 05/07/24.
//

import Foundation
import Supabase

struct Doctor: Codable, Hashable {
    let userId: UUID
    let firstName: String
    let lastName: String
    let dateOfBirth: Date
    let gender: Gender
    let phoneNumber: Int
    let email: String
    let qualification: String
    let experienceSince: Date
    let dateOfJoining: Date
    let departmentId: UUID
    let fee: Int
    let doctorSettings: DoctorSettings?
    
    var name: String {
        "\(firstName) \(lastName)"
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case dateOfBirth = "date_of_birth"
        case gender
        case phoneNumber = "phone_number"
        case email
        case qualification
        case experienceSince = "experience_since"
        case dateOfJoining = "date_of_joining"
        case departmentId = "department_id"
        case fee
        case doctorSettings = "doctor_settings"
    }
    
    static func == (lhs: Doctor, rhs: Doctor) -> Bool {
        lhs.userId == rhs.userId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(userId)
    }
    
    var settings: DoctorSettings {
        doctorSettings ?? DoctorSettings.getDefaultSettings(userId: userId)
    }
    
    static var sample: Doctor {
        Doctor(userId: UUID(),
               firstName: "John",
               lastName: "Doe",
               dateOfBirth: Date(),
               gender: .male,
               phoneNumber: 1234567890,
               email: "doctor@ihospital.viperadnan.com",
               qualification: "MBBS",
               experienceSince: Date(),
               dateOfJoining: Date(),
               departmentId: UUID(),
               fee: 799,
               doctorSettings: DoctorSettings.sample)
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decode(UUID.self, forKey: .userId)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        
        let dateOfBirthString = try container.decode(String.self, forKey: .dateOfBirth)
        let dateOfJoiningString = try container.decode(String.self, forKey: .dateOfJoining)
        let experienceSinceString = try container.decode(String.self, forKey: .experienceSince)
        
        guard let dateOfBirth = Doctor.dateFormatter.date(from: dateOfBirthString),
              let dateOfJoining = Doctor.dateFormatter.date(from: dateOfJoiningString),
              let experienceSince = Doctor.dateFormatter.date(from: experienceSinceString) else {
            throw DecodingError.dataCorruptedError(forKey: .dateOfBirth, in: container, debugDescription: "Invalid date format")
        }
        self.dateOfBirth = dateOfBirth
        self.dateOfJoining = dateOfJoining
        self.experienceSince = experienceSince
        
        gender = try container.decode(Gender.self, forKey: .gender)
        phoneNumber = try container.decode(Int.self, forKey: .phoneNumber)
        email = try container.decode(String.self, forKey: .email)
        qualification = try container.decode(String.self, forKey: .qualification)
        departmentId = try container.decode(UUID.self, forKey: .departmentId)
        fee = try container.decode(Int.self, forKey: .fee)
        doctorSettings = try container.decodeIfPresent(DoctorSettings.self, forKey: .doctorSettings)
    }
    
    init(userId: UUID, firstName: String, lastName: String, dateOfBirth: Date, gender: Gender, phoneNumber: Int, email: String, qualification: String, experienceSince: Date, dateOfJoining: Date, departmentId: UUID, fee:Int, doctorSettings: DoctorSettings?) {
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.gender = gender
        self.phoneNumber = phoneNumber
        self.email = email
        self.qualification = qualification
        self.experienceSince = experienceSince
        self.dateOfJoining = dateOfJoining
        self.departmentId = departmentId
        self.fee = fee
        self.doctorSettings = doctorSettings
    }
    
    static let supabaseSelectQuery = "*, doctor_settings(*)"
    
    static func fetchAll() async throws -> [Doctor] {
        let response: [Doctor] = try await supabase.from(SupabaseTable.doctors.id)
            .select()
            .execute()
            .value
        
        return response
    }
    
    static func fetchDepartmentWise(departmentId: UUID) async throws -> [Doctor] {
        let response:[Doctor] = try await supabase.from(SupabaseTable.doctors.id)
            .select(supabaseSelectQuery)
            .eq("department_id", value: departmentId)
            .execute()
            .value
        
        return response
    }
    
    func getSettings() async throws -> DoctorSettings {
        try await DoctorSettings.get(userId: userId)
    }
    
    func fetchAppointments(for date: Date) async throws -> [Appointment] {
        let response:[Appointment]? = try? await supabase.from(SupabaseTable.appointments.id)
            .select(Appointment.supabaseSelectQuery)
            .eq("doctor_id", value: userId)
            .gte("date", value: date.startOfDay.ISO8601Format())
            .lt("date", value: date.endOfDay.ISO8601Format())
            .execute()
            .value
        
        guard let response = response else {
            return []
        }
        
        return response
    }
    
    func getAvailableTimeSlots(for date: Date) async throws -> [(Date, Bool)] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE" // Day of the week
        let dayOfWeek = dateFormatter.string(from: date)
        
        guard settings.selectedDays.contains(dayOfWeek) else {
            return []
        }
        
        let appointments = try await fetchAppointments(for: date)
        let calendar = Calendar.current
        var availableSlots: [(Date, Bool)] = []
        let today = Date()
        
        let startTime = date.startOfDay == today.startOfDay ? calendar.date(byAdding: .hour, value: 1, to: today)!.nextQuarter : settings.startTime
        
        var currentTime = calendar.date(bySettingHour: calendar.component(.hour, from: startTime), minute: calendar.component(.minute, from: startTime), second: 0, of: date)!
        let endTime = calendar.date(bySettingHour: calendar.component(.hour, from: settings.endTime), minute: calendar.component(.minute, from: settings.endTime), second: 0, of: date)!
        
        while currentTime < endTime {
            let isBooked = appointments.contains { appointment in
                calendar.isDate(appointment.date, equalTo: currentTime, toGranularity: .minute)
            }
            availableSlots.append((currentTime, isBooked))
            currentTime = calendar.date(byAdding: .minute, value: 15, to: currentTime)!
        }
        
        return availableSlots
    }
}

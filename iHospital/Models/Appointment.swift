//
//  Appointment.swift
//  iHospital
//
//  Created by Adnan Ahmad on 05/07/24.
//

import Foundation
import Supabase
import SwiftUI

class Appointment: Codable, Hashable {
    let id: Int
    let patient: Patient
    let doctor: Doctor
    let user: SupaUser
    var date: Date
    let appointmentStatus: AppointmentStatus
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case patient
        case doctor
        case user
        case date
        case appointmentStatus = "appointment_status"
        case createdAt = "created_at"
    }
    
    static func == (lhs: Appointment, rhs: Appointment) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static let iso8601Formatter = ISO8601DateFormatter()
    
    static let supabaseSelectQuery = "*, doctor:doctor_id(\(Doctor.supabaseSelectQuery)), patient:patient_id(*), user:user_id(*)"
    
    static let sample: Appointment = Appointment(
        id: 1,
        patient: Patient.sample,
        doctor: Doctor.sample,
        date: Date(),
        appointmentStatus: .pending,
        user: SupaUser.sample,
        createdAt: Date()
    )

    init(id: Int = 0, patient: Patient, doctor: Doctor, date: Date, appointmentStatus: AppointmentStatus, user: SupaUser, createdAt: Date = Date()) {
        self.id = id
        self.patient = patient
        self.doctor = doctor
        self.date = date
        self.appointmentStatus = appointmentStatus
        self.user = user
        self.createdAt = createdAt
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        patient = try container.decode(Patient.self, forKey: .patient)
        doctor = try container.decode(Doctor.self, forKey: .doctor)
        user = try container.decode(SupaUser.self, forKey: .user)
        
        let dateString = try container.decode(String.self, forKey: .date)
        let createdAtString = try container.decode(String.self, forKey: .createdAt)
        
        guard let date = Appointment.iso8601Formatter.date(from: dateString),
              let createdAt = Appointment.iso8601Formatter.date(from: createdAtString) else {
            throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "Invalid date format")
        }
        
        self.date = date
        self.createdAt = createdAt
        appointmentStatus = try container.decode(AppointmentStatus.self, forKey: .appointmentStatus)
    }

    /// Books an appointment for the given patient and doctor
    /// - Parameters:
    ///   - patientId: The UUID of the patient
    ///   - doctorId: The UUID of the doctor
    ///   - date: The date of the appointment
    ///   - userId: The UUID of the user
    /// - Returns: The booked appointment
    static func bookAppointment(patientId: UUID, doctorId: UUID, date: Date, userId: UUID) async throws -> Appointment {
        let response: Appointment = try await supabase
            .from(SupabaseTable.appointments.id)
            .insert([
                "patient_id": patientId.uuidString,
                "doctor_id": doctorId.uuidString,
                "date": date.ISO8601Format(),
                "appointment_status": AppointmentStatus.pending.rawValue,
                "user_id": userId.uuidString,
                "created_at": Date().ISO8601Format()
            ])
            .select(supabaseSelectQuery)
            .single()
            .execute()
            .value

        return response
    }
    
    /// Fetches all appointments for the current user
    /// - Returns: An array of appointments
    static func fetchAllAppointments() async throws -> [Appointment] {
        guard let user = SupaUser.shared else { return [] }
        
        let response: [Appointment] = try await supabase
            .from(SupabaseTable.appointments.id)
            .select(supabaseSelectQuery)
            .eq("user_id", value: user.id.uuidString)
            .execute()
            .value
        
        return response
    }
    
    /// Reschedules the appointment to a new date
    /// - Parameter date: The new date for the appointment
    /// - Returns: The rescheduled appointment
    func reschedule(date: Date) async throws -> Appointment {
        self.date = date
        
        let response: Appointment = try await supabase
            .from(SupabaseTable.appointments.id)
            .update([
                "date": date.ISO8601Format()
            ])
            .eq("id", value: id)
            .select(Appointment.supabaseSelectQuery)
            .single()
            .execute()
            .value
        
        return response
    }
    
    /// Cancels the appointment
    func cancel() async throws {
        try await supabase
            .from(SupabaseTable.appointments.id)
            .update([
                "appointment_status": AppointmentStatus.cancelled.rawValue
            ])
            .eq("id", value: id)
            .execute()
    }
    
    /// Fetches the medical record for the appointment if it is completed
    /// - Returns: The medical record if the appointment is completed, otherwise nil
    func fetchMedicalRecord() async throws -> MedicalRecord? {
        guard appointmentStatus == .completed else {
            return nil
        }
        
        let response: MedicalRecord = try await supabase.from(SupabaseTable.medicalRecords.id)
            .select(MedicalRecord.supabaseSelectQuery)
            .eq("appointment_id", value: id)
            .single()
            .execute()
            .value
        
        return response
    }
    
    /// Fetches the lab tests for the appointment if it is completed
    /// - Returns: An array of lab tests if the appointment is completed, otherwise nil
    func fetchLabTests() async throws -> [LabTest]? {
        guard appointmentStatus == .completed else {
            return nil
        }
        
        let response: [LabTest] = try await supabase.from(SupabaseTable.labTests.id)
            .select(LabTest.supabaseSelectQuery)
            .eq("appointment_id", value: id)
            .execute()
            .value
        
        return response
    }
}

enum PaymentStatus: String, Codable {
    case paid
    case pending
    case failed
    case cancelled
    
    var color: Color {
        switch self {
        case .paid:
            return .green
        case .pending:
            return .orange
        case .failed:
            return .red
        case .cancelled:
            return .gray
        }
    }
}

enum AppointmentStatus: String, Codable {
    case completed
    case confirmed
    case pending
    case cancelled
    
    var color: Color {
        switch self {
        case .completed:
            return .green
        case .confirmed:
            return .blue
        case .pending:
            return .yellow
        case .cancelled:
            return .red
        }
    }
}

enum AppointmentError: Error, LocalizedError {
    case invalidBookingDetails

    var errorDescription: String? {
        switch self {
        case .invalidBookingDetails:
            return "Invalid booking details"
        }
    }
}

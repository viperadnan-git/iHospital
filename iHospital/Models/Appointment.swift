//
//  Appointment.swift
//  iHospital
//
//  Created by Adnan Ahmad on 05/07/24.
//

import Foundation
import Supabase

struct Appointment: Codable, Hashable {
    let id: Int
    let patientId: UUID
    let doctorId: UUID
    let date: Date
    let paymentStatus: PaymentStatus
    let appointmentStatus: AppointmentStatus
    let userId: UUID
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case patientId = "patient_id"
        case doctorId = "doctor_id"
        case date
        case paymentStatus = "payment_status"
        case appointmentStatus = "appointment_status"
        case userId = "user_id"
        case createdAt = "created_at"
    }
    
    static let iso8601Formatter = ISO8601DateFormatter()
    
    static let sample: Appointment = Appointment(
        id: 1,
        patientId: UUID(),
        doctorId: UUID(),
        date: Date(),
        paymentStatus: .pending,
        appointmentStatus: .pending,
        userId: UUID()
    )

    init(id: Int = 0, patientId: UUID, doctorId: UUID, date: Date, paymentStatus: PaymentStatus, appointmentStatus: AppointmentStatus, userId: UUID, createdAt: Date = Date()) {
        self.id = id
        self.patientId = patientId
        self.doctorId = doctorId
        self.date = date
        self.paymentStatus = paymentStatus
        self.appointmentStatus = appointmentStatus
        self.userId = userId
        self.createdAt = createdAt
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        patientId = try container.decode(UUID.self, forKey: .patientId)
        doctorId = try container.decode(UUID.self, forKey: .doctorId)
        
        let dateString = try container.decode(String.self, forKey: .date)
        let createdAtString = try container.decode(String.self, forKey: .createdAt)
        
        guard let date = Appointment.iso8601Formatter.date(from: dateString),
                let createdAt = Appointment.iso8601Formatter.date(from: createdAtString) else {
            throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "Invalid time format")
        }
        
        self.date = date
        self.createdAt = createdAt
        
        paymentStatus = try container.decode(PaymentStatus.self, forKey: .paymentStatus)
        appointmentStatus = try container.decode(AppointmentStatus.self, forKey: .appointmentStatus)
        userId = try container.decode(UUID.self, forKey: .userId)
    }

    static func bookAppointment(patientId: UUID, doctorId: UUID, date: Date, userId: UUID) async throws -> Appointment {
        let newAppointment = Appointment(
            patientId: patientId,
            doctorId: doctorId,
            date: date,
            paymentStatus: .pending,
            appointmentStatus: .pending,
            userId: userId
        )

        let response: Appointment = try await supabase
            .from("appointments")
            .insert([
                "patient_id": patientId.uuidString,
                "doctor_id": doctorId.uuidString,
                "date": date.ISO8601Format(),
                "payment_status": newAppointment.paymentStatus.rawValue,
                "appointment_status": newAppointment.appointmentStatus.rawValue,
                "user_id": userId.uuidString,
                "created_at": newAppointment.createdAt.ISO8601Format()
            ])
            .select("*")
            .single()
            .execute()
            .value

        return response
    }
}

enum PaymentStatus: String, Codable {
    case paid
    case pending
    case failed
}

enum AppointmentStatus: String, Codable {
    case confirmed
    case pending
    case cancelled
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

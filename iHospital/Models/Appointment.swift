//
//  Appointment.swift
//  iHospital
//
//  Created by Adnan Ahmad on 05/07/24.
//

import Foundation

struct Appointment: Codable {
    let appointmentId: UUID
    let patient: Patient
    let doctor: Doctor
    let date: Date
    let paymentStatus: PaymentStatus
    let status: AppointmentStatus
    let bookedOn: Date
    
    enum CodingKeys: String, CodingKey {
        case appointmentId = "appointment_id"
        case patient
        case doctor
        case date
        case paymentStatus
        case status
        case bookedOn = "created_at"
    }
    
    func bookAppointment(doctor: Doctor, date: Date, patient:Patient) {
        // check if doctor has appointment on that specific date
        
        _ = Appointment(
            appointmentId: UUID(),
            patient: patient,
            doctor: doctor,
            date: date,
            paymentStatus: .pending,
            status: .pending, bookedOn: Date()
        )
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

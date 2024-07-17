//
//  BookingViewModel.swift
//  iHospital
//
//  Created by Adnan Ahmad on 07/07/24.
//

import SwiftUI
import Combine

class BookingViewModel: ObservableObject {
    @Published var doctor: Doctor?
    @Published var selectedSlot: Date?
    @Published var forDate: Date = Date()
    @Published var bookedAppointment: Appointment?
    
    func bookAppointment(patient: Patient) async throws -> Appointment {
        guard let doctor = doctor, let selectedSlot = selectedSlot else {
            throw AppointmentError.invalidBookingDetails
        }

        let appointment = try await Appointment.bookAppointment(patientId: patient.id, doctorId: doctor.userId, date: selectedSlot, userId: patient.userId)
        return appointment
    }
}

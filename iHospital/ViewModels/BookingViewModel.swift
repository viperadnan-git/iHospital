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
    
    /// Books an appointment for the given patient with the selected doctor and slot
    /// - Parameter patient: The patient for whom the appointment is to be booked
    /// - Returns: The booked appointment
    /// - Throws: An error of type `AppointmentError` if booking details are invalid or the booking fails
    func bookAppointment(patient: Patient) async throws -> Appointment {
        guard let doctor = doctor, let selectedSlot = selectedSlot else {
            throw AppointmentError.invalidBookingDetails
        }

        let appointment = try await Appointment.bookAppointment(patientId: patient.id, doctorId: doctor.userId, date: selectedSlot, userId: patient.userId)
        
        DispatchQueue.main.async {
            self.bookedAppointment = appointment
        }
        
        return appointment
    }
}

//
//  AppointmentBooking.swift
//  iHospital
//
//  Created by Adnan Ahmad on 07/07/24.
//

import SwiftUI

struct AppointmentBooking: View {
    @EnvironmentObject var booking: BookingViewModel
    @EnvironmentObject var patientViewModel: PatientViewModel
    
    @StateObject var errorAlertMessage = ErrorAlertMessage(title: "Unable to book appointment")
    @State private var bookedAppointment: Appointment?
    
    var body: some View {
        NavigationStack {
            VStack {
                if let doctor = booking.doctor, let bookingDate = booking.selectedSlot {
                    Text("Booking with \(doctor.name)")
                        .font(.largeTitle)
                        .padding()
                    
                    Text("Appointment Date: \(bookingDate, style: .date) at \(bookingDate, style: .time)")
                        .font(.title2)
                        .padding()
                    
                    Text("Patient: \(patientViewModel.currentPatient?.name ?? "Unknown")")
                    
                    Picker("Select Patient", selection: $patientViewModel.currentPatient) {
                        ForEach(patientViewModel.patients, id: \.patientId) { patient in
                            Text(patient.name).tag(patient as Patient?)
                        }
                    }
                    
                    Button(action: confirmBooking) {
                        Text("Confirm Booking")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                }
            }
            .navigationTitle("Confirm Booking")
            .navigationBarTitleDisplayMode(.inline)
            .errorAlert(errorAlertMessage: errorAlertMessage)
            .navigationDestination(for: Appointment.self) { appointment in
                AppointmentDetailView(appointment: appointment)
            }
        }
    }
    
    func confirmBooking() {
        guard let patient = patientViewModel.currentPatient else {
            errorAlertMessage.message = "Please add a patient"
            return
        }
        
        Task {
            do {
                let appointment = try await booking.bookAppointment(patient: patient)
                bookedAppointment = appointment
                // Navigate to the detail view
                booking.selectedSlot = nil // Clear the selected slot after booking
                if let bookedAppointment {
                    self.bookedAppointment = bookedAppointment
                }
                print("Appointment booked successfully: \(appointment)")
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
}

#Preview {
    AppointmentBooking()
        .environmentObject(BookingViewModel())
        .environmentObject(PatientViewModel())
}

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
    
    @State private var bookedAppointment: Appointment?
    @State private var showPatientSheet = false
    @State private var isLoading = false
    @StateObject var errorAlertMessage = ErrorAlertMessage(title: "Unable to book appointment")
    
    var body: some View {
        
        VStack {
            if let doctor = booking.doctor, let bookingDate = booking.selectedSlot {
                Form {
                    Section {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .padding()
                            .foregroundColor(.accent)
                            .accessibility(label: Text("Doctor Profile Picture"))
                    }.frame(maxWidth: .infinity, alignment: .center)
                    
                    Section(header: Text("Booking Information")) {
                        HStack {
                            Text("Doctor Name")
                            Spacer()
                            Text(doctor.name)
                        }
                        
                        HStack {
                            Text("Appointment Date")
                            Spacer()
                            Text("\(bookingDate, style: .date)")
                        }
                        
                        HStack {
                            Text("Appointment Time")
                            Spacer()
                            Text("\(bookingDate, style: .time)")
                        }
                        
                        if let settings = doctor.settings {
                            HStack {
                                Text("Appointment Fee")
                                Spacer()
                                Text(settings.fee.formatted(.currency(code: "INR")))
                            }
                        }
                    }
                    
                    if patientViewModel.patients.isEmpty {
                        Button(action: { showPatientSheet.toggle() }) {
                            Text("Add Patient")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.accent)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }.buttonStyle(PlainButtonStyle())
                    } else {
                        Picker("Patient", selection: $patientViewModel.currentPatient) {
                            ForEach(patientViewModel.patients, id: \.id) { patient in
                                Text(patient.name).tag(patient as Patient?)
                            }
                        }
                        
                        LoaderButton(isLoading: $isLoading, action: confirmBooking) {
                            Text("Confirm Booking")
                        }
                    }
                }
            }
        }  .navigationTitle("Confirm Booking")
            .navigationBarTitleDisplayMode(.inline)
            .errorAlert(errorAlertMessage: errorAlertMessage)
            .navigationDestination(for: Appointment.self) { appointment in
                AppointmentDetailView(appointment: appointment)
            }.sheet(isPresented: $showPatientSheet) {
                AddPatientView(showPatientSheet: $showPatientSheet)
            }
    }
    
    func confirmBooking() {
        guard let patient = patientViewModel.currentPatient else {
            if patientViewModel.patients.isEmpty {
                showPatientSheet.toggle()
                return
            }
            errorAlertMessage.message = "Please select a patient"
            return
        }
        
        Task {
            isLoading = true
            defer {
                isLoading = false
            }
            
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

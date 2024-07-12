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
        NavigationStack {
            VStack {
                if let doctor = booking.doctor, let bookingDate = booking.selectedSlot {
                    Form {
                        Section {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .padding()
                                .foregroundColor(Color(.systemGray))
                                .accessibility(label: Text("Doctor Profile Picture"))
                        }.frame(maxWidth: .infinity, alignment: .center)
                        
                        Section(header: Text("Appointment Information")) {
                            HStack {
                                Text("Doctor's Name")
                                Spacer()
                                Text(doctor.name)
                            }
                            
                            HStack {
                                Text("Date")
                                Spacer()
                                Text("\(bookingDate, style: .date)")
                            }
                            
                            HStack {
                                Text("Time")
                                Spacer()
                                Text("\(bookingDate, style: .time)")
                            }
                            
                            if let settings = doctor.settings {
                                HStack {
                                    Text("Doctor's Fee")
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
                
                NavigationLink(
                    destination: AppointmentDetailView(appointment: bookedAppointment ?? Appointment.sample),
                    isActive: Binding<Bool>(
                        get: { bookedAppointment != nil },
                        set: { if !$0 { bookedAppointment = nil } }
                    )
                ) {
                    EmptyView()
                }
            }
            .navigationTitle("Confirm Booking")
            .navigationBarTitleDisplayMode(.inline)
            .errorAlert(errorAlertMessage: errorAlertMessage)
            .sheet(isPresented: $showPatientSheet) {
                AddPatientView(showPatientSheet: $showPatientSheet)
            }
        }
    }
    
    func confirmBooking() {
        guard let patient = patientViewModel.currentPatient else {
            if (patientViewModel.patients.isEmpty) {
                showPatientSheet.toggle()
            } else {
                errorAlertMessage.message = "Please select a patient"
            }
            return
        }
        
        Task {
            isLoading = true
            defer { isLoading = false }
            
            do {
                let appointment = try await booking.bookAppointment(patient: patient)
                bookedAppointment = appointment
                booking.selectedSlot = nil // Clear the selected slot after booking
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

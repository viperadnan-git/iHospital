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
    
    @Environment(\.navigation) private var navigation
    @State private var showPatientSheet = false
    @State private var showPaymentPage = false
    @State private var isLoading = false
    @State private var bookedAppointment: Appointment?
    @State private var isPaymentSuccessful = false
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
                            
                            HStack {
                                Text("Doctor's Fee")
                                Spacer()
                                Text(doctor.fee.formatted(.currency(code: "INR")))
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
            }
            .navigationTitle("Confirm Booking")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Appointment.self) {
                AppointmentDetailView(appointment: $0)
            }
            .errorAlert(errorAlertMessage: errorAlertMessage)
            .sheet(isPresented: $showPatientSheet) {
                AddPatientView(showPatientSheet: $showPatientSheet)
            }
            .sheet(isPresented: $showPaymentPage) {
                if let bookedAppointment = bookedAppointment {
                    PaymentPageSingleView(isSuccess: $isPaymentSuccessful, paymentType: .appointment, refrenceId: bookedAppointment.id)
                }
            }
            .onChange(of: isPaymentSuccessful) { newValue in
                if newValue, let bookedAppointment = bookedAppointment {
                    navigation.path.append(bookedAppointment)
                } else {
                    errorAlertMessage.message = "Failed to book appointment"
                }
            }
        }
    }
    
    func confirmBooking() {
        guard let patient = patientViewModel.currentPatient else {
            if patientViewModel.patients.isEmpty {
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
                booking.selectedSlot = nil // Clear the selected slot after booking
                bookedAppointment = appointment
                showPaymentPage = true
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

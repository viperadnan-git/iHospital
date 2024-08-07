//
//  AppointmentDetailView.swift
//  iHospital
//
//  Created by Adnan Ahmad on 17/07/24.
//

import SwiftUI

struct AppointmentDetailView: View {
    var appointment: Appointment
    
    @State private var showRescheduleSheet = false
    @State private var showCancelAlert = false
    @State private var showPaymentPage = false
    @State private var isRescheduling = false
    @State private var isLoading = false
    @State private var selectedSlot: Date?
    @State private var availableSlots: [(Date, Bool)] = []
    @State private var rescheduleDate = Date()
    @StateObject private var errorAlertMessage = ErrorAlertMessage(title: "Error")
    
    @EnvironmentObject private var viewModel: AppointmentViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Appointment Detail")) {
                    HStack {
                        Text("Doctor")
                        Spacer()
                        Text(appointment.doctor.name)
                            .accessibilityLabel("Doctor's name: \(appointment.doctor.name)")
                    }
                    HStack {
                        Text("Patient")
                        Spacer()
                        Text(appointment.patient.name)
                            .accessibilityLabel("Patient's name: \(appointment.patient.name)")
                    }
                    HStack {
                        Text("Date")
                        Spacer()
                        Text("\(appointment.date, style: .date)")
                            .accessibilityLabel("Appointment date: \(appointment.date, style: .date)")
                    }
                    HStack {
                        Text("Time")
                        Spacer()
                        Text("\(appointment.date, style: .time)")
                            .accessibilityLabel("Appointment time: \(appointment.date, style: .time)")
                    }
                    HStack {
                        Text("Status")
                        Spacer()
                        Text(appointment.appointmentStatus.rawValue.capitalized)
                            .foregroundColor(appointment.appointmentStatus.color)
                            .accessibilityLabel("Status: \(appointment.appointmentStatus.rawValue.capitalized)")
                    }
                    HStack {
                        Text("Appointment ID")
                        Spacer()
                        Text("#\(appointment.id.string)")
                            .accessibilityLabel("Appointment ID: \(appointment.id.string)")
                    }
                }
                
                if appointment.appointmentStatus == .completed {
                    Section {
                        NavigationLink(destination: AppointmentMedicalRecordDetailView(appointment: appointment)) {
                            Text("View Medical Record")
                                .accessibilityLabel("View Medical Record")
                        }
                        NavigationLink(destination: AppointmentLabTestDetailView(appointment: appointment)) {
                            Text("View Lab Reports")
                                .accessibilityLabel("View Lab Reports")
                        }
                    }
                }
                
                if appointment.appointmentStatus != .completed && appointment.date > Date() {
                    Section(header: Text("Actions")) {
                        if appointment.date > Date().addingTimeInterval(4 * 60 * 60) {
                            Button("Reschedule Appointment") {
                                showRescheduleSheet = true
                            }
                            .accessibilityLabel("Reschedule Appointment")
                            Button("Cancel Appointment") {
                                showCancelAlert = true
                            }
                            .foregroundColor(.red)
                            .accessibilityLabel("Cancel Appointment")
                        } else {
                            Text("You can reschedule or cancel up to 4 hours before the appointment time.")
                                .accessibilityLabel("You can reschedule or cancel up to 4 hours before the appointment time.")
                        }
                    }
                }
                
                if appointment.appointmentStatus == .pending && appointment.date > Date() {
                    Section(header: Text("Make Payment")) {
                        VStack(alignment: .center) {
                            Button("Pay Now") {
                                showPaymentPage = true
                            }
                            .accessibilityLabel("Pay Now")
                        }
                    }
                }
            }
            .alert("Cancel Appointment", isPresented: $showCancelAlert) {
                Button("Cancel", role: .destructive) {
                    cancelAppointment()
                }
                Button("Dismiss", role: .cancel) {}
            } message: {
                Text("Are you sure you want to cancel this appointment?")
                    .accessibilityLabel("Are you sure you want to cancel this appointment?")
            }
            .sheet(isPresented: $showRescheduleSheet) {
                NavigationStack {
                    VStack {
                        Form {
                            Section {
                                if let lastDate = Calendar.current.date(byAdding: .day, value: appointment.doctor.settings.priorBookingDays, to: Date()) {
                                    DatePicker("Select Date", selection: $rescheduleDate, in: Date()...lastDate, displayedComponents: .date)
                                        .onChange(of: rescheduleDate) { _ in
                                            fetchAvailableSlots()
                                        }.onAppear {
                                            fetchAvailableSlots()
                                        }
                                        .accessibilityLabel("Select Date")
                                }
                            }
                            Section(header: Text("Slots")) {
                                if isLoading {
                                    ProgressView()
                                        .accessibilityLabel("Loading available slots")
                                } else if availableSlots.isEmpty {
                                    Text("No slots available for \(rescheduleDate, style: .date)")
                                        .foregroundColor(.gray)
                                        .accessibilityLabel("No slots available for \(rescheduleDate, style: .date)")
                                } else {
                                    SlotListView(slots: availableSlots, doctor: .constant(appointment.doctor), selection: $selectedSlot)
                                }
                            }
                            if selectedSlot != nil {
                                Section {
                                    VStack(alignment: .center) {
                                        Button("Reschedule Appointment") {
                                            rescheduleAppointment()
                                        }
                                        .accessibilityLabel("Reschedule Appointment")
                                    }
                                }
                            }
                        }
                    }
                    .navigationTitle("Reschedule Appointment")
                    .navigationBarTitleDisplayMode(.inline)
                    .errorAlert(errorAlertMessage: errorAlertMessage)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                showRescheduleSheet = false
                            }
                            .accessibilityLabel("Cancel")
                            .accessibilityHint("Tap to cancel rescheduling")
                        }
                    }
                }
            }
            .sheet(isPresented: $showPaymentPage) {
                PaymentPageSingleView(paymentType: .appointment, refrenceId: appointment.id, isSuccess: $isRescheduling)
                    .accessibilityLabel("Payment Page")
            }
        }
        .navigationTitle("Appointment Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func cancelAppointment() {
        Task {
            do {
                try await viewModel.cancelAppointment(appointment: appointment)
                dismiss()
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
    
    private func rescheduleAppointment() {
        guard let selectedSlot = selectedSlot else {
            errorAlertMessage.message = "Please select a slot to reschedule"
            return
        }
        
        Task {
            isRescheduling = true
            defer { isRescheduling = false }
            do {
                try await viewModel.rescheduleAppointment(appointment: appointment, newDate: selectedSlot)
                appointment.date = selectedSlot
                showRescheduleSheet = false
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
    
    private func fetchAvailableSlots() {
        availableSlots = []
        
        Task {
            isLoading = true
            defer {
                isLoading = false
            }
            
            do {
                let slots = try await appointment.doctor.getAvailableTimeSlots(for: rescheduleDate)
                availableSlots = slots
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
}

#Preview {
    AppointmentDetailView(appointment: .sample)
}

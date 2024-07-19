//
//  AppointmentLabTestDetailView.swift
//  iHospital
//
//  Created by Adnan Ahmad on 17/07/24.
//

import SwiftUI

struct AppointmentLabTestDetailView: View {
    var appointment: Appointment
    
    @State var labTests: [LabTest] = []
    @State var isLoading = true
    
    @StateObject private var errorAlertMessage = ErrorAlertMessage(title: "Failed to load")
    
    var body: some View {
        VStack {
            if isLoading {
                Spacer()
                ProgressView()
                    .accessibilityLabel("Loading lab tests")
                Spacer()
            } else {
                if !labTests.isEmpty {
                    LabTestListView(labTests: $labTests)
                        .accessibilityLabel("List of lab tests for appointment with Doctor \(appointment.doctor.name)")
                } else {
                    Spacer()
                    Text("No lab tests have been suggested in this appointment.")
                        .foregroundColor(.gray)
                        .accessibilityLabel("No lab tests have been suggested in this appointment.")
                    Spacer()
                }
            }
        }
        .onAppear {
            fetchLabTests()
        }
        .navigationTitle("Lab Reports")
        .navigationBarTitleDisplayMode(.inline)
        .errorAlert(errorAlertMessage: errorAlertMessage)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Appointment Lab Test Detail View")
    }
    
    func fetchLabTests() {
        Task {
            defer {
                isLoading = false
            }
            
            do {
                if let labTests = try await appointment.fetchLabTests() {
                    self.labTests = labTests
                }
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
}

#Preview {
    AppointmentLabTestDetailView(appointment: .sample)
}

//
//  AppointmentMedicalRecordDetailView.swift
//  iHospital
//
//  Created by Adnan Ahmad on 17/07/24.
//

import SwiftUI

struct AppointmentMedicalRecordDetailView: View {
    var appointment: Appointment
    
    @State var medicalRecords: MedicalRecord? = nil
    @State var isLoading = true
    
    @StateObject private var errorAlertMessage = ErrorAlertMessage(title: "Failed to load")
    
    var body: some View {
        VStack {
            if isLoading {
                Spacer()
                ProgressView()
                    .accessibilityLabel("Loading medical record")
                Spacer()
            } else {
                if let medicalRecords = medicalRecords {
                    MedicalRecordDetailView(medicalRecord: medicalRecords)
                        .accessibilityLabel("Medical record details for \(appointment.patient.name) with Doctor \(appointment.doctor.name)")
                } else {
                    Text("Failed to load medical record")
                        .foregroundColor(.gray)
                        .accessibilityLabel("Failed to load medical record")
                }
            }
        }
        .onAppear {
            fetchMedicalRecord()
        }
        .navigationTitle(appointment.doctor.name)
        .navigationBarTitleDisplayMode(.inline)
        .errorAlert(errorAlertMessage: errorAlertMessage)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Appointment Medical Record Detail View")
    }
    
    func fetchMedicalRecord() {
        Task {
            defer {
                isLoading = false
            }
            
            do {
                let medicalRecords = try await appointment.fetchMedicalRecord()
                self.medicalRecords = medicalRecords
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
}

#Preview {
    AppointmentMedicalRecordDetailView(appointment: .sample)
}

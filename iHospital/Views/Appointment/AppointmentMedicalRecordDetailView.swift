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
        if isLoading {
            VStack {
                Spacer()
                ProgressView()
                Spacer()
            }.onAppear {
                fetchMedicalRecord()
            }.navigationTitle(appointment.doctor.name)
            .navigationBarTitleDisplayMode(.inline)
            .errorAlert(errorAlertMessage: errorAlertMessage)
        } else {
            if let medicalRecords = medicalRecords {
                MedicalRecordDetailView(medicalRecord: medicalRecords)
            }
        }
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

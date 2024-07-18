//
//  MedicalRecordDetailView.swift
//  iHospital
//
//  Created by Adnan Ahmad on 16/07/24.
//

import SwiftUI

struct MedicalRecordDetailView: View {
    let medicalRecord: MedicalRecord
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Appointment")) {
                    HStack {
                        Image(systemName: "stethoscope")
                            .accessibilityHidden(true)
                        Text(medicalRecord.appointment.doctor.name)
                            .accessibilityLabel("Doctor: \(medicalRecord.appointment.doctor.name)")
                    }
                    
                    HStack {
                        Image(systemName: "person")
                            .accessibilityHidden(true)
                        Text(medicalRecord.appointment.patient.name)
                            .accessibilityLabel("Patient: \(medicalRecord.appointment.patient.name)")
                    }
                    
                    HStack {
                        Image(systemName: "calendar")
                            .accessibilityHidden(true)
                        Text(medicalRecord.appointment.date.dateTimeString)
                            .accessibilityLabel("Date: \(medicalRecord.appointment.date.dateTimeString)")
                    }

                    HStack {
                        Image(systemName: "dollarsign.circle")
                            .accessibilityHidden(true)
                        Text(medicalRecord.appointment.doctor.fee.currency)
                            .accessibilityLabel("Fee: \(medicalRecord.appointment.doctor.fee.currency)")
                    }
                }
                
                Section(header: Text("Prescription Note")) {
                    Text(medicalRecord.note)
                        .accessibilityLabel("Prescription Note: \(medicalRecord.note)")
                }
                
                Section(header: Text("Pencil Note")) {
                    Image.asyncImage(loadData: medicalRecord.loadImage, cacheKey: "MRIMAGE#\(medicalRecord.id)")
                        .accessibilityLabel("Pencil Note Image")
                }
                
                if !medicalRecord.medicines.isEmpty {
                    Section(header: Text("Medicines")) {
                        ForEach(medicalRecord.medicines, id:\.self) { medicine in
                            Text(medicine)
                                .accessibilityLabel("Medicine: \(medicine)")
                        }
                    }
                }
            }
        }
        .navigationTitle(medicalRecord.appointment.doctor.name)
        .navigationBarTitleDisplayMode(.inline)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Medical record details for Doctor: \(medicalRecord.appointment.doctor.name)")
    }
}

#Preview {
    MedicalRecordDetailView(medicalRecord: MedicalRecord.sample)
}

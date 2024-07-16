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
                        Text(medicalRecord.appointment.doctor.name)
                    }
                    
                    HStack {
                        Image(systemName: "person")
                        Text(medicalRecord.appointment.patient.name)
                    }
                    
                    HStack {
                        Image(systemName: "calendar")
                        Text(medicalRecord.appointment.date.dateTimeString)
                    }

                    HStack {
                        Image(systemName: "dollarsign.circle")
                        Text(medicalRecord.appointment.doctor.fee.currency)
                    }
                }
                
                Section(header: Text("Prescription Note")) {
                    Text(medicalRecord.note)
                }
                
                Section(header: Text("Pencil Note")) {
                    Image.asyncImage(loadData: medicalRecord.loadImage)
                }
                
                if !medicalRecord.medicines.isEmpty {
                    Section(header: Text("Medicines")) {
                        ForEach(medicalRecord.medicines, id:\.self) { medicine in
                            HStack {
                                Text(medicine)
                            }
                        }
                    }
                }
            }
        }.navigationTitle(medicalRecord.appointment.doctor.name)
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MedicalRecordDetailView(medicalRecord: MedicalRecord.sample)
}

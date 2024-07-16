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
        }
    }
}

#Preview {
    MedicalRecordDetailView(medicalRecord: MedicalRecord.sample)
}

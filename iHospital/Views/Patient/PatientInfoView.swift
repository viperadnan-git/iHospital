//
//  PatientInfoView.swift
//  iHospital
//
//  Created by Adnan Ahmad on 10/07/24.
//

import SwiftUI

struct PatientInfoView: View {
    var patientId: UUID
    
    @State private var showEditSheet = false
    
    @EnvironmentObject var patientViewModel: PatientViewModel
    
    var body: some View {
        if let patient = patientViewModel.patients.first(where: { $0.id == patientId }) {
            Form {
                Section(header: Text("Patient Information")) {
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                        Text(patient.name)
                            .accessibilityLabel("Patient Name")
                            .accessibilityValue(patient.name)
                    }
                    
                    HStack {
                        Image(systemName: "heart.text.square.fill")
                        Text(patient.gender.id.capitalized)
                            .accessibilityLabel("Gender")
                            .accessibilityValue(patient.gender.id.capitalized)
                    }
                    
                    HStack {
                        Image(systemName: "drop.degreesign.fill")
                        Text(patient.bloodGroup.id)
                            .accessibilityLabel("Blood Group")
                            .accessibilityValue(patient.bloodGroup.id)
                    }
                    
                    HStack {
                        Image(systemName: "calendar")
                        Text(patient.dateOfBirth.dateString)
                            .accessibilityLabel("Date of Birth")
                            .accessibilityValue(patient.dateOfBirth.dateString)
                    }
                    
                    HStack {
                        Image(systemName: "phone.fill")
                        Text(patient.phoneNumber.string)
                            .accessibilityLabel("Phone Number")
                            .accessibilityValue(patient.phoneNumber.string)
                    }
                    
                    HStack {
                        Image(systemName: "lines.measurement.vertical")
                        Text(patient.height?.string ?? "Not available")
                            .foregroundColor(patient.height != nil ? Color(.label) : Color(.systemGray))
                            .accessibilityLabel("Height")
                            .accessibilityValue(patient.height?.string ?? "Not available")
                    }
                    
                    HStack {
                        Image(systemName: "scalemass.fill")
                        Text(patient.weight?.string ?? "Not available")
                            .foregroundColor(patient.weight != nil ? Color(.label) : Color(.systemGray))
                            .accessibilityLabel("Weight")
                            .accessibilityValue(patient.weight?.string ?? "Not available")
                    }
                    
                    HStack {
                        Image(systemName: "location.circle.fill")
                        Text(patient.address)
                            .foregroundColor(!patient.address.isEmpty ? Color(.label) : Color(.systemGray))
                            .accessibilityLabel("Address")
                            .accessibilityValue(patient.address.isEmpty ? "Not available" : patient.address)
                    }
                }
            }
            .navigationTitle("Patient Information")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showEditSheet) {
                AddPatientView(patient: patient, showPatientSheet: $showEditSheet)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        showEditSheet.toggle()
                    }
                    .accessibilityLabel("Edit Patient Information")
                    .accessibilityHint("Opens the edit patient form")
                }
            }
        } else {
            Text("Patient not found")
                .accessibilityLabel("Patient not found")
        }
    }
}

#Preview {
    PatientInfoView(patientId: Patient.sample.id)
}

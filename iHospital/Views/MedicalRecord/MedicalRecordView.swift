//
//  MedicalRecord.swift
//  iHospital
//
//  Created by Adnan Ahmad on 16/07/24.
//

import SwiftUI

struct MedicalRecordView: View {
    @EnvironmentObject private var patientViewModel: PatientViewModel
    
    @StateObject private var errorAlertMessage = ErrorAlertMessage(title: "Failed to load medical records")
    @StateObject private var viewModel = MedicalRecordViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    Picker("Select Patient", selection: $patientViewModel.currentPatient) {
                        ForEach(patientViewModel.patients, id: \.id) { patient in
                            Text(patient.name).tag(patient as Patient?)
                        }
                    }
                    .accessibilityLabel("Select Patient")
                }
                
                if viewModel.isLoading || patientViewModel.isLoading {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                        .accessibilityLabel("Loading medical records")
                } else if viewModel.medicalRecords.isEmpty {
                    Spacer()
                    Text(patientViewModel.patients.isEmpty ? "You don't have any patients yet, start by adding a patient first." : "No medical records found for this profile.")
                        .foregroundStyle(.gray)
                        .padding()
                        .accessibilityLabel(patientViewModel.patients.isEmpty ? "You don't have any patients yet, start by adding a patient first." : "No medical records found for this profile.")
                } else {
                    List(viewModel.medicalRecords) { medicalRecord in
                        NavigationLink(destination: MedicalRecordDetailView(medicalRecord: medicalRecord)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(medicalRecord.appointment.doctor.name).bold()
                                        .accessibilityLabel("Doctor: \(medicalRecord.appointment.doctor.name)")
                                    HStack {
                                        Text(medicalRecord.appointment.date.dateTimeString)
                                        Text("•")
                                        Text(medicalRecord.id.string)
                                    }
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                                    .accessibilityLabel("Date: \(medicalRecord.appointment.date.dateTimeString), Record ID: \(medicalRecord.id.string)")
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                
                Spacer()
            }
            .navigationTitle("Medical Records")
            .errorAlert(errorAlertMessage: errorAlertMessage)
            .onAppear {
                if let patient = patientViewModel.currentPatient {
                    viewModel.fetchMedicalRecords(patient: patient)
                }
            }
            .refreshable {
                if let patient = patientViewModel.currentPatient {
                    viewModel.fetchMedicalRecords(patient: patient, showLoader: false, force: true)
                }
            }
            .onChange(of: patientViewModel.currentPatient) { _ in
                if let patient = patientViewModel.currentPatient {
                    viewModel.fetchMedicalRecords(patient: patient, force: true)
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Medical records view")
    }
}

#Preview {
    MedicalRecordView()
        .environmentObject(PatientViewModel())
}

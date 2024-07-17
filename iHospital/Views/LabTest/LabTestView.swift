//
//  LabTestView.swift
//  iHospital
//
//  Created by Shoaib Akhtar on 10/07/24.
//

import SwiftUI

struct LabTestView: View {
    @EnvironmentObject private var patientViewModel: PatientViewModel
    
    @StateObject private var viewModel = LabTestsViewModel()
    @StateObject private var errorAlertMessage = ErrorAlertMessage(title: "Failed to load test reports")
    
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
                }
                
                if viewModel.isLoading || patientViewModel.isLoading {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else if viewModel.labTests.isEmpty {
                    Spacer()
                    Text(patientViewModel.patients.isEmpty ? "You don't have any patients yet, start by adding a patient first." : "No medical records found for this profile.")
                        .foregroundStyle(.gray)
                        .padding()
                } else {
                    LabTestListView(labTests: $viewModel.labTests)
                }
                
                Spacer()
            }.navigationTitle("Test Reports")
                .errorAlert(errorAlertMessage: errorAlertMessage)
                .onAppear {
                    if let patient = patientViewModel.currentPatient {
                        viewModel.fetchLabTests(patient: patient)
                    }
                }
                .refreshable {
                    if let patient = patientViewModel.currentPatient {
                        viewModel.fetchLabTests(patient: patient, showLoader: false, force: true)
                    }
                }
                .onChange(of: patientViewModel.currentPatient) { _ in
                    if let patient = patientViewModel.currentPatient {
                        viewModel.fetchLabTests(patient: patient, force: true)
                    }
                }
        }
    }
}


struct LabTestListView: View {
    @Binding var labTests: [LabTest]
    
    var body: some View {
        List(labTests) { labTest in
            NavigationLink(destination: LabTestDetailView(labTest: labTest)) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(labTest.test.name).bold()
                        HStack {
                            Text(labTest.appointment.doctor.name)
                            Text("•")
                            Text(labTest.appointment.date, style: .date)
                        }
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        
                    }
                    Spacer()
                    switch labTest.status {
                    case .completed:
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(labTest.status.color)
                    case .pending:
                        Image(systemName: "clock.fill")
                            .foregroundColor(labTest.status.color)
                    case .waiting:
                        Image(systemName: "clock.fill")
                            .foregroundColor(labTest.status.color)
                    case .inProgress:
                        Image(systemName: "clock.fill")
                            .foregroundColor(labTest.status.color)
                    }
                }
            }
        }.listStyle(PlainListStyle())
    }
}


#Preview {
    LabTestView()
}

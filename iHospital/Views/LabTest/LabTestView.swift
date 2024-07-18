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
                    .accessibilityLabel("Select Patient")
                }
                
                if viewModel.isLoading || patientViewModel.isLoading {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                        .accessibilityLabel("Loading test reports")
                } else if viewModel.labTests.isEmpty {
                    Spacer()
                    Text(patientViewModel.patients.isEmpty ? "You don't have any patients yet, start by adding a patient first." : "No medical records found for this profile.")
                        .foregroundStyle(.gray)
                        .padding()
                        .accessibilityLabel(patientViewModel.patients.isEmpty ? "You don't have any patients yet, start by adding a patient first." : "No medical records found for this profile.")
                } else {
                    LabTestListView(labTests: $viewModel.labTests)
                }
                
                Spacer()
            }
            .navigationTitle("Test Reports")
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
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Lab test view")
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
                            .accessibilityLabel("Test: \(labTest.test.name)")
                        HStack {
                            Text(labTest.appointment.doctor.name)
                            Text("•")
                            Text(labTest.appointment.date, style: .date)
                        }
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .accessibilityLabel("Doctor: \(labTest.appointment.doctor.name), Date: \(labTest.appointment.date, style: .date)")
                    }
                    Spacer()
                    switch labTest.status {
                    case .completed:
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(labTest.status.color)
                            .accessibilityLabel("Status: Completed")
                    case .pending, .waiting, .inProgress:
                        Image(systemName: "clock.fill")
                            .foregroundColor(labTest.status.color)
                            .accessibilityLabel("Status: \(labTest.status.rawValue.capitalized)")
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Lab test list")
    }
}

#Preview {
    LabTestView()
        .environmentObject(PatientViewModel())
}

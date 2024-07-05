//
//  ProfileView.swift
//  iHospital
//
//  Created by Adnan Ahmad on 05/07/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var patientViewModel: PatientViewModel
    @State private var showPatientSheet = false

    var body: some View {
        Form {
            Section(header: Text("Your Patients")) {
                ForEach(patientViewModel.patients, id: \.patientId) { patient in
                    NavigationLink(destination: EditPatientView(patient: patient)) {
                        Text(patient.name)
                    }
                }
            }
            
            Section {
                HStack {
                    Image(systemName: "plus")
                    Text("Add new patient").onTapGesture {
                        showPatientSheet.toggle()
                    }
                }
            }
        }
        .sheet(isPresented: $showPatientSheet) {
            AddPatientView(showPatientSheet: $showPatientSheet)
                .environmentObject(patientViewModel)
        }
        .navigationBarTitle("Patients", displayMode: .inline)
    }
}

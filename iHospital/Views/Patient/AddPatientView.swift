//
//  UserDetailsView.swift
//  iHospital
//
//  Created by Shoaib Akhtar on 04/07/24.
//

import SwiftUI

struct AddPatientView: View {
    @EnvironmentObject var patientViewModel: PatientViewModel

    @Binding var showPatientSheet: Bool
    
    @State private var fullName: String = ""
    @State private var phoneNumber: String = ""
    @State private var bloodGroup: BloodGroup = .Unknown
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var dateOfBirth = Date()
    @State private var address: String = ""
    
    @StateObject private var errorAlertMessage = ErrorAlertMessage(title: "Can't add patient")

    let bloodGroups = BloodGroup.allCases

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Full Name", text: $fullName)
                    TextField("Phone Number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                    
                    Picker("Blood Group", selection: $bloodGroup) {
                        ForEach(bloodGroups, id: \.self) { group in
                            Text(group.rawValue)
                        }
                    }
                    
                    DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                    TextField("Height (cm)", text: $height)
                        .keyboardType(.decimalPad)
                    TextField("Weight (kg)", text: $weight)
                        .keyboardType(.decimalPad)
                }

                Section(header: Text("Address")) {
                    TextField("Address", text: $address)
                }
            }
            .navigationBarTitle("Add New Patient", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done", action: onSave))
        }.errorAlert(errorAlertMessage: errorAlertMessage)
    }
    
    
    func onSave() {
        guard !fullName.isEmpty else {
            errorAlertMessage.message = "Please enter a name"
            return
        }
        
        guard let phoneNumber = Int(phoneNumber) else {
            errorAlertMessage.message = "Please enter a valid phone number"
            return
        }
        
        
        Task {
            do {
                try await patientViewModel.addPatient(
                    name: fullName,
                    phoneNumber: phoneNumber,
                    bloodGroup: bloodGroup,
                    dateOfBirth: dateOfBirth,
                    height: Double(height),
                    weight: Double(weight),
                    address: address
                )
                self.showPatientSheet.toggle()
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
}

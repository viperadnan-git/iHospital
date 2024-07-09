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
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var gender: Gender = .male
    @State private var phoneNumber: String = ""
    @State private var bloodGroup: BloodGroup = .Unknown
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var dateOfBirth = Date()
    @State private var address: String = ""
    
    @StateObject private var errorAlertMessage = ErrorAlertMessage(title: "Can't add patient")

    let bloodGroups = BloodGroup.allCases
    let genders = Gender.allCases

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    HStack {
                        TextField("First Name", text: $firstName)
                        Divider()
                        TextField("Last Name", text: $lastName)
                    }
                    
                    Picker("Gender", selection: $gender) {
                        ForEach(genders, id: \.self) { group in
                            Text(group.id.capitalized)
                        }
                    }
                    
                    Picker("Blood Group", selection: $bloodGroup) {
                        ForEach(bloodGroups, id: \.self) { group in
                            Text(group.rawValue)
                        }
                    }
                    
                    DatePicker("Date of Birth", selection: $dateOfBirth, in: ...Date(), displayedComponents: .date)
                    
                    TextField("Phone Number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                    
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
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showPatientSheet.toggle()
                    }
                }
            }
        }.errorAlert(errorAlertMessage: errorAlertMessage)
    }
    
    
    func onSave() {
        guard !firstName.isEmpty, !lastName.isEmpty, !phoneNumber.isEmpty  else {
            errorAlertMessage.message = "Please enter a valid name and phone number"
            return
        }
        
        guard firstName.isAlphabets else {
            errorAlertMessage.message = "First name should contain only alphabets"
            return
        }
        
        guard lastName.isAlphabetsAndSpaces else {
            errorAlertMessage.message = "Last name should contain only alphabets and spaces"
            return
        }
        
        guard phoneNumber.count == 10 else {
            errorAlertMessage.message = "Please enter a valid 10-digit phone number"
            return
        }
        
        guard let phoneNumber = Int(phoneNumber) else {
            errorAlertMessage.message = "Please enter a valid phone number"
            return
        }
        
        
        Task {
            do {
                try await patientViewModel.addPatient(
                    firstName: firstName,
                    lastName: lastName,
                    gender: gender,
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

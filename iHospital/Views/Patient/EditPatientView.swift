//
//  EditPatientView.swift
//  iHospital
//
//  Created by Aditya on 05/07/24.
//

import SwiftUI

struct EditPatientView: View {
    let patient: Patient
    let bloodGroups = BloodGroup.allCases
    let genders = Gender.allCases

    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var gender: Gender = .male
    @State private var phoneNumber: String = ""
    @State private var bloodGroup: BloodGroup = .Unknown
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var dateOfBirth = Date()
    @State private var address: String = ""
    
    @EnvironmentObject var patientViewModel: PatientViewModel
    
    @State private var isSaving = false
    @StateObject private var errorAlertMessage = ErrorAlertMessage(title: "Can't update patient")
    
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
                    
                    DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                    
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
        }.onAppear {
            firstName = patient.firstName
            lastName = patient.lastName
            gender = patient.gender
            phoneNumber = "\(patient.phoneNumber)"
            bloodGroup = patient.bloodGroup
            height = String(patient.height ?? 0)
            weight = String(patient.weight ?? 0)
            address = patient.address
        }
        .navigationTitle("Edit Details")
        .navigationBarItems(trailing:  Button(action: {
            isSaving = true
            savePatient()
        }) {
            if isSaving {
                ProgressView()
            } else {
                Text("Save")
            }
        })
    }
                            
    private func savePatient() {
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
        
        patient.firstName = firstName
        patient.lastName = lastName
        patient.phoneNumber = phoneNumber
        patient.bloodGroup = bloodGroup
        patient.dateOfBirth = dateOfBirth
        patient.address = address
        
        Task {
            isSaving = true
            defer {
                isSaving = false
            }
            
            do {
                try await patientViewModel.save(patient: patient)
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
}

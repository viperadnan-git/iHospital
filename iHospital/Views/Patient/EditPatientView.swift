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
    @FocusState private var focusedField: Field?
    
    enum Field {
        case firstName
        case lastName
        case phoneNumber
        case height
        case weight
        case address
    }
    
    var body: some View {
        
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    HStack {
                        TextField("First Name", text: $firstName)
                            .focused($focusedField, equals: .firstName)
                            .submitLabel(.next)
                            .onSubmit {
                                focusedField = .lastName
                            }
                        Divider()
                        TextField("Last Name", text: $lastName)
                            .focused($focusedField, equals: .lastName)
                            .submitLabel(.next)
                            .onSubmit {
                                focusedField = .phoneNumber
                            }
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
                        .focused($focusedField, equals: .phoneNumber)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .height
                        }
                    
                    TextField("Height (cm)", text: $height)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .height)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .weight
                        }
                    
                    TextField("Weight (kg)", text: $weight)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .weight)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .address
                        }
                }

                Section(header: Text("Address")) {
                    TextField("Address", text: $address)
                        .focused($focusedField, equals: .address)
                        .submitLabel(.done)
                        .onSubmit {
                            savePatient()
                        }
                }
            }
        }
        .onAppear {
            firstName = patient.firstName
            lastName = patient.lastName
            gender = patient.gender
            phoneNumber = "\(patient.phoneNumber)"
            bloodGroup = patient.bloodGroup
            dateOfBirth = patient.dateOfBirth
            address = patient.address
            
            if let height = patient.height {
                self.height = "\(height)"
            }
            
            if let weight = patient.weight {
                self.weight = "\(weight)"
            }
        }
        .navigationTitle("Edit Details")
        .navigationBarItems(trailing: Button(action: {
            isSaving = true
            savePatient()
        }) {
            if isSaving {
                ProgressView()
            } else {
                Text("Save")
            }
        })
        .errorAlert(errorAlertMessage: errorAlertMessage)
        .onChange(of: isSaving) { newValue in
            if newValue {
                hideKeyboard()
            }
        }
    }
                            
    private func savePatient() {
        guard !firstName.isEmpty, !lastName.isEmpty, !phoneNumber.isEmpty  else {
            errorAlertMessage.message = "Please enter a valid name and phone number"
            return
        }
        
        guard firstName.isAlphabets, firstName.count < 25 else {
            errorAlertMessage.message = "First name must contain only alphabets and max 25 characters."
            return
        }
        
        guard lastName.isAlphabetsAndSpaces, lastName.count < 25 else {
            errorAlertMessage.message = "Last name must contain only alphabets, spaces and max 25 characters."
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
        
        if !address.trimmed.isEmpty {
            guard 10 < address.count,  address.count < 100 else {
                errorAlertMessage.message = "Address must be between 10 to 100 characters"
                return
            }
        }
        
        patient.firstName = firstName.trimmed.capitalized
        patient.lastName = lastName.trimmed.capitalized
        patient.phoneNumber = phoneNumber
        patient.bloodGroup = bloodGroup
        patient.dateOfBirth = dateOfBirth
        patient.address = address.trimmed
        
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
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    EditPatientView(patient: Patient.sample)
}


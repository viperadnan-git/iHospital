//
//  UserDetailsView.swift
//  iHospital
//
//  Created by Shoaib Akhtar on 04/07/24.
//

import SwiftUI

struct AddPatientView: View {
    @EnvironmentObject var patientViewModel: PatientViewModel
    
    var patient: Patient? = nil
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
    @FocusState private var focusedField: Field?
    
    @State private var firstNameError: String?
    @State private var lastNameError: String?
    @State private var phoneNumberError: String?
    @State private var heightError: String?
    @State private var weightError: String?
    @State private var addressError: String?
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    enum Field {
        case firstName
        case lastName
        case phoneNumber
        case height
        case weight
        case address
    }
    
    let bloodGroups = BloodGroup.allCases
    let genders = Gender.allCases
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    HStack {
                        VStack(alignment: .leading) {
                            TextField("First Name", text: $firstName)
                                .focused($focusedField, equals: .firstName)
                                .submitLabel(.next)
                                .onSubmit { focusedField = .lastName }
                                .onChange(of: firstName) { _ in validateFirstName() }
                                .overlay(validationIcon(for: firstNameError), alignment: .trailing)
                        }
                        Divider()
                        VStack(alignment: .leading) {
                            TextField("Last Name", text: $lastName)
                                .focused($focusedField, equals: .lastName)
                                .submitLabel(.next)
                                .onSubmit { focusedField = .phoneNumber }
                                .onChange(of: lastName) { _ in validateLastName() }
                                .overlay(validationIcon(for: lastNameError), alignment: .trailing)
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
                    
                    DatePicker("Date of Birth", selection: $dateOfBirth, in: ...Date(), displayedComponents: .date)
                    
                    VStack(alignment: .leading) {
                        TextField("Phone Number", text: $phoneNumber)
                            .keyboardType(.phonePad)
                            .focused($focusedField, equals: .phoneNumber)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .height }
                            .onChange(of: phoneNumber) { _ in validatePhoneNumber() }
                            .overlay(validationIcon(for: phoneNumberError), alignment: .trailing)
                    }
                }
                
                Section(header: Text("Optional Information")) {
                    VStack(alignment: .leading) {
                        TextField("Height (cm)", text: $height)
                            .keyboardType(.decimalPad)
                            .focused($focusedField, equals: .height)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .weight }
                            .onChange(of: height) { _ in validateHeight() }
                            .overlay(validationIcon(for: heightError), alignment: .trailing)
                    }
                    
                    VStack(alignment: .leading) {
                        TextField("Weight (kg)", text: $weight)
                            .keyboardType(.decimalPad)
                            .focused($focusedField, equals: .weight)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .address }
                            .onChange(of: weight) { _ in validateWeight() }
                            .overlay(validationIcon(for: weightError), alignment: .trailing)
                    }
                    VStack(alignment: .leading) {
                        TextField("Address", text: $address)
                            .focused($focusedField, equals: .address)
                            .submitLabel(.done)
                            .onSubmit { onSave() }
                            .onChange(of: address) { _ in validateAddress() }
                            .overlay(validationIcon(for: addressError), alignment: .trailing)
                    }
                }
            }.navigationBarTitle("\(patient == nil ? "Add New":"Edit") Patient", displayMode: .inline)
                .navigationBarItems(trailing: Button((patient != nil) ? "Save" : "Done", action: onSave))
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            showPatientSheet.toggle()
                        }
                    }
                }
                .errorAlert(errorAlertMessage: errorAlertMessage)
                .onChange(of: showPatientSheet) { newValue in
                    if !newValue {
                        hideKeyboard()
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Validation Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                        showNextError()
                    })
                }.onAppear(perform: onAppear)
        }
    }
    
    func validationIcon(for error: String?) -> some View {
        Group {
            if let error = error {
                Button(action: {
                    alertMessage = error
                    showAlert.toggle()
                }) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.red)
                }
            }
        }
    }
    
    func validateFirstName() {
        if firstName.isEmpty {
            firstNameError = "First name is required."
        } else if !firstName.isAlphabets {
            firstNameError = "First name must contain only alphabets."
        } else if firstName.count >= 25 {
            firstNameError = "First name must be less than 25 characters."
        } else {
            firstNameError = nil
        }
    }
    
    func validateLastName() {
        if lastName.isEmpty {
            lastNameError = "Last name is required."
        } else if !lastName.isAlphabetsAndSpaces {
            lastNameError = "Last name must contain only alphabets and spaces."
        } else if lastName.count >= 25 {
            lastNameError = "Last name must be less than 25 characters."
        } else {
            lastNameError = nil
        }
    }
    
    func validatePhoneNumber() {
        if phoneNumber.isEmpty {
            phoneNumberError = "Phone number is required."
        } else if !phoneNumber.isPhoneNumber {
            phoneNumberError = "Phone number must be exactly 10 digits."
        } else {
            phoneNumberError = nil
        }
    }
    
    func validateHeight() {
        if let heightValue = Double(height), heightValue > 0 {
            heightError = nil
        } else if height.isEmpty {
            heightError = nil
        } else {
            heightError = "Height must be a positive number."
        }
    }
    
    func validateWeight() {
        if let weightValue = Double(weight), weightValue > 0 {
            weightError = nil
        } else if weight.isEmpty {
        } else {
            weightError = "Weight must be a positive number."
        }
    }
    
    func validateAddress() {
        if address.trimmed.isEmpty {
            addressError = nil
        } else if address.count < 10 || address.count > 100 {
            addressError = "Address must be between 10 and 100 characters."
        } else {
            addressError = nil
        }
    }
    
    func showNextError() {
        if let error = firstNameError ?? lastNameError ?? phoneNumberError ?? heightError ?? weightError ?? addressError {
            alertMessage = error
            showAlert.toggle()
        }
    }
    
    func onAppear() {
        if let patient = patient {
            firstName = patient.firstName
            lastName = patient.lastName
            gender = patient.gender
            bloodGroup = patient.bloodGroup
            dateOfBirth = patient.dateOfBirth
            phoneNumber = patient.phoneNumber.string
            height = patient.height?.string ?? ""
            weight = patient.weight?.string ?? ""
            address = patient.address
        }
    }
    
    func onSave() {
        validateFirstName()
        validateLastName()
        validatePhoneNumber()
        validateHeight()
        validateWeight()
        validateAddress()
        
        guard firstNameError == nil,
              lastNameError == nil,
              phoneNumberError == nil,
              heightError == nil,
              weightError == nil,
              addressError == nil,
              !firstName.isEmpty,
              !lastName.isEmpty,
              !phoneNumber.isEmpty else {
            showNextError()
            return
        }
        
        guard let phoneNumber = Int(phoneNumber) else {
            errorAlertMessage.message = "Please enter a valid phone number."
            return
        }
        
        Task {
            do {
                if let patient = patient {
                    patient.firstName = firstName.trimmed.capitalized
                    patient.lastName = lastName.trimmed.capitalized
                    patient.gender = gender
                    patient.phoneNumber = phoneNumber
                    patient.bloodGroup = bloodGroup
                    patient.dateOfBirth = dateOfBirth
                    patient.address = address.trimmed
                    
                    try await patientViewModel.save(patient: patient)
                } else {
                    try await patientViewModel.addPatient(
                        firstName: firstName.trimmed.capitalized,
                        lastName: lastName.trimmed.capitalized,
                        gender: gender,
                        phoneNumber: phoneNumber,
                        bloodGroup: bloodGroup,
                        dateOfBirth: dateOfBirth,
                        height: Double(height),
                        weight: Double(weight),
                        address: address.trimmed
                    )
                }
                
                self.showPatientSheet.toggle()
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    AddPatientView(showPatientSheet: .constant(true))
}

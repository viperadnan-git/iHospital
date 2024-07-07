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

    @State private var name: String = ""
    @State private var phoneNumber: String = ""
    @State private var bloodGroup: BloodGroup = .Unknown
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var dateOfBirth = Date()
    @State private var address: String = ""
    
    
    var body: some View {
        
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Full Name", text: $name)
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
        }.onAppear {
          
            
            name = patient.name
            phoneNumber = "\(patient.phoneNumber)"
            bloodGroup = patient.bloodGroup
            height = String(patient.height ?? 0)
            weight = String(patient.weight ?? 0)
            address = patient.address
        }
        .navigationTitle("Edit Details")
        .navigationBarItems(trailing: Button("Save"){
            print("Save action Tapped")
        })
    }
                            
    
}

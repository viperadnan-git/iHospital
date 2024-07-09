//
//  ProfileView.swift
//  iHospital
//
//  Created by Adnan Ahmad on 05/07/24.
//

import SwiftUI

struct ProfileView: View {
    @State private var showPatientSheet = false
    @State private var showLogoutAlert = false
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var patientViewModel: PatientViewModel

    @StateObject private var errorAlertMessage = ErrorAlertMessage(title: "Error")

    var body: some View {
        Form {
            if let user = authViewModel.user {
                Section(header: Text("Your Profile")) {
                    HStack {
                        Image(systemName: "person")
                        Text(user.name)
                    }
                    
                    HStack {
                        Image(systemName: "envelope")
                        Text(user.email)
                    }
                    
                    HStack {
                        Image(systemName: "phone")
                        Text(String(user.phoneNumber))
                    }
                }
            }
          
            
            Section(header: Text("Your Family/Friends")) {
                ForEach(patientViewModel.patients, id: \.id) { patient in
                    NavigationLink(destination: EditPatientView(patient: patient)) {
                        Text(patient.name)
                    }
                }
                HStack {
                    Image(systemName: "plus")
                    Text("Add new person").onTapGesture {
                        showPatientSheet.toggle()
                    }
                }
            }

            
            Section(header: Text("Settings")) {
                Button(role: .destructive, action: {
                    showLogoutAlert.toggle()
                }) {
                    Text("Log Out")
                }.frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .sheet(isPresented: $showPatientSheet) {
            AddPatientView(showPatientSheet: $showPatientSheet)
                .environmentObject(patientViewModel)
        }.alert(isPresented: $showLogoutAlert) {
            Alert(
                title: Text("Logout"),
                message: Text("Are you sure you want to logout?"),
                primaryButton: .destructive(Text("Logout")) {
                    logOut()
                },
                secondaryButton: .cancel()
            )
        }
        .navigationBarTitle("Patients", displayMode: .inline)
    }
    
    func logOut() {
        Task {
            do {
                try await SupaUser.logOut()
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
}

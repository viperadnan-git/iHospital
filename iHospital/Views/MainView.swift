//
//  MainView.swift
//  iHospital
//
//  Created by Adnan Ahmad on 03/07/24.
//

import SwiftUI

struct MainView: View {
    @StateObject private var patientViewModel = PatientViewModel()
    @StateObject private var authViewModel = AuthViewModel()
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            // Home Tab
            DashboardView()
                .tabItem {
                    Label("Home", systemImage: selection == 0 ? "house.fill" : "house")
                        .accessibilityLabel("Home")
                        .accessibilityHint("Navigates to the home screen")
                }
                .tag(0)
            
            // Appointment Tab
            AppointmentListView()
                .tabItem {
                    Label("Appointment", systemImage: selection == 1 ? "calendar" : "calendar")
                        .accessibilityLabel("Appointment")
                        .accessibilityHint("Navigates to the appointment screen")
                }
                .tag(1)
            
            // Medical Record Tab
            MedicalRecordView()
                .tabItem {
                    Label("Medical Record", systemImage: selection == 2 ? "doc.text.fill" : "doc.text")
                        .accessibilityLabel("Medical Record")
                        .accessibilityHint("Navigates to the medical record screen")
                }
                .tag(2)
            
            // Lab Records Tab
            LabTestView()
                .tabItem {
                    Label("Lab Records", systemImage: selection == 3 ? "flask.fill" : "flask")
                        .accessibilityLabel("Lab Records")
                        .accessibilityHint("Navigates to the lab records screen")
                }
                .tag(3)
        }
        .environmentObject(authViewModel)
        .environmentObject(patientViewModel)
    }
}

#Preview {
    MainView()
}

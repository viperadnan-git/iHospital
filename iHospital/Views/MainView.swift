//
//  ContentView.swift
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
            DashboardView()
                .tabItem {
                    Label("Home", systemImage: selection == 0 ? "house.fill" : "house")
                }.tag(0)
            AppointmentView()
                .tabItem {
                    Label("Appointment", systemImage: selection == 1 ? "calendar" : "calendar")
                }.tag(1)
            MedicalRecordView()
                .tabItem {
                    Label("Medical Record", systemImage: selection == 2 ? "doc.text.fill" : "doc.text")
                }.tag(2)
            LabTestView()
                .tabItem {
                    Label("Lab Test", systemImage: selection == 2 ? "flask.fill" : "flask")
                }.tag(3)
        }
        .environmentObject(authViewModel)
        .environmentObject(patientViewModel)
    }
}

#Preview {
    MainView()
}

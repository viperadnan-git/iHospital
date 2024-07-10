//
//  ContentView.swift
//  iHospital
//
//  Created by Adnan Ahmad on 03/07/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var patientViewModel = PatientViewModel()
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            DashboardView()
                .tabItem {
                    Label("Home", systemImage: selection == 0 ? "house.fill" : "house")
                }
            
            
            AppointmentView()
                .tabItem {
                    Label("Appointment", systemImage: selection == 1 ? "calendar.circle.fill" : "calendar.circle")
                }
            LabTestView()
                .tabItem {
                    Label("Lab Test", systemImage: selection == 1 ? "flask.fill" : "flask")
                }
            
        }.environmentObject(patientViewModel)
    }
}

#Preview {
    MainView()
}

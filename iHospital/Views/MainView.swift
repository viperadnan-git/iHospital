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
            
            DashboardView()
                .tabItem {
                    Label("Home", systemImage: selection == 1 ? "house.fill" : "house")
                }
        }.environmentObject(patientViewModel)
    }
}

#Preview {
    MainView()
}

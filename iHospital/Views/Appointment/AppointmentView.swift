//
//  AppointmentView.swift
//  iHospital
//
//  Created by Adnan Ahmad on 07/07/24.
//

import SwiftUI

struct AppointmentView: View {
    @StateObject private var viewModel = AppointmentViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Appointments", selection: $viewModel.selectedSegment) {
                    ForEach(AppointmentViewModel.Segment.allCases, id: \.self) { segment in
                        Text(segment.rawValue).tag(segment)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                HStack {
                    TextField("Filter", text: $viewModel.filterText)
                        .withIcon("maginfyingglass")
                        .paddedTextFieldStyle()
                        .padding(.leading)
                    
                    Picker("Sort by", selection: $viewModel.sortOption) {
                        ForEach(AppointmentViewModel.SortOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.horizontal)
                }
                
                List {
                    ForEach(viewModel.selectedSegment == .upcoming ? viewModel.upcomingAppointments : viewModel.pastAppointments, id: \.self) { appointment in
                        VStack(alignment: .leading) {
                            Text("Doctor: \(appointment.doctor.name)")
                            Text("Patient: \(appointment.patient.name)")
                            Text("Date: \(appointment.date, style: .date) at \(appointment.date, style: .time)")
                            Text("Status: \(appointment.appointmentStatus.rawValue.capitalized)")
                        }
                        .padding()
                    }
                }.listStyle(.plain)
            }
            .navigationTitle("Appointments")
            .onAppear {
                Task {
                    await viewModel.fetchAppointments()
                }
            }
        }
    }
}

#Preview {
    AppointmentView()
}

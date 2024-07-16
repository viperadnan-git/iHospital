//
//  AppointmentView.swift
//  iHospital
//
//  Created by Adnan Ahmad on 07/07/24.
//

import SwiftUI

struct AppointmentView: View {
    @StateObject private var viewModel = AppointmentViewModel()
    
    @StateObject private var errorAlertMessage = ErrorAlertMessage(title: "Failed to load appointments")
    
    var body: some View {
        NavigationView {
            VStack {
                
                
                HStack { 
                    Picker("Appointments", selection: $viewModel.selectedSegment) {
                        ForEach(AppointmentViewModel.Segment.allCases, id: \.self) { segment in
                            Text(segment.rawValue).tag(segment)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(8)
                    .padding(.leading)
                    Picker("Sort by", selection: $viewModel.sortOption) {
                        ForEach(AppointmentViewModel.SortOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.trailing)
                }
                
                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else if viewModel.selectedSegment == .upcoming && viewModel.upcomingAppointments.isEmpty || viewModel.selectedSegment == .past && viewModel.pastAppointments.isEmpty {
                    Spacer()
                    Image(systemName: "calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding()
                        .foregroundColor(Color(.systemGray5))
                    Text("No appointments found")
                        .foregroundColor(Color(.systemGray))
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.selectedSegment == .upcoming ? viewModel.upcomingAppointments : viewModel.pastAppointments, id: \.self) { appointment in
                            AppointmentCard(appointment: appointment)
                        }
                    }.listStyle(.plain)
                        .refreshable {
                            viewModel.fetchAppointments()
                        }
                }
                
                Spacer()
            }
            .navigationTitle("Appointments")
            .navigationBarTitleDisplayMode(.inline)
            .errorAlert(errorAlertMessage: errorAlertMessage)
            .searchable(text: $viewModel.filterText)
        }
    }
}

#Preview {
    AppointmentView()
}

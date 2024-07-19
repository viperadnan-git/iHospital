//
//  AppointmentView.swift
//  iHospital
//
//  Created by Adnan Ahmad on 07/07/24.
//

import SwiftUI

struct AppointmentListView: View {
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
                    .accessibilityLabel("Appointments segment")
                    .accessibilityHint("Select to view upcoming or past appointments")
                    
                    Picker("Sort by", selection: $viewModel.sortOption) {
                        ForEach(AppointmentViewModel.SortOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.trailing)
                    .accessibilityLabel("Sort by")
                    .accessibilityHint("Select sorting option for appointments")
                }
                
                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                        .accessibilityLabel("Loading appointments")
                    Spacer()
                } else if (viewModel.selectedSegment == .upcoming && viewModel.upcomingAppointments.isEmpty) || (viewModel.selectedSegment == .past && viewModel.pastAppointments.isEmpty) {
                    Spacer()
                    Image(systemName: "calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding()
                        .foregroundColor(Color(.systemGray5))
                        .accessibilityHidden(true)
                    Text("No \(viewModel.selectedSegment == .upcoming ? "upcoming" : "past") appointments")
                        .foregroundColor(Color(.systemGray))
                        .accessibilityLabel("No \(viewModel.selectedSegment == .upcoming ? "upcoming" : "past") appointments")
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.selectedSegment == .upcoming ? viewModel.upcomingAppointments : viewModel.pastAppointments, id: \.self) { appointment in
                            NavigationLink(destination: AppointmentDetailView(appointment: appointment).environmentObject(viewModel)) {
                                AppointmentCard(appointment: appointment)
                                    .accessibilityLabel("Appointment with \(appointment.doctor.name) on \(appointment.date, style: .date) at \(appointment.date, style: .time)")
                            }
                        }
                    }
                    .listStyle(.plain)
                }
                
                Spacer()
            }
            .onAppear {
                viewModel.fetchAppointments(showLoader: true)
            }
            .refreshable {
                viewModel.fetchAppointments(showLoader: false, force: true)
            }
            .navigationTitle("Appointments")
            .navigationBarTitleDisplayMode(.inline)
            .errorAlert(errorAlertMessage: errorAlertMessage)
            .searchable(text: $viewModel.filterText)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Appointments List View")
        }
    }
}

#Preview {
    AppointmentListView()
}

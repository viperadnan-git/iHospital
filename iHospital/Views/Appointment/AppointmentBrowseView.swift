//
//  AppointmentBrowseView.swift
//  iHospital
//
//  Created by Adnan Ahmad on 05/07/24.
//

import SwiftUI

struct AppointmentBrowseView: View {
    @StateObject private var booking = BookingViewModel()
    @State private var showSearch = false
    @State private var selectedSearchResult: Search?
    @State private var selectedDepartment: Department? = nil
    
    @State var departments: [Department] = [Department.defaultDepartment]
    
    @StateObject private var errorAlertMessage = ErrorAlertMessage()
    
    var body: some View {
        ScrollView {
            VStack {
                HorizontalCalenderView(selectedDate: $booking.forDate)
                Divider()
                
                HStack {
                    Menu {
                        ForEach(departments, id: \.id) { department in
                            Button(action: {
                                selectedSearchResult = nil
                                selectedDepartment = department
                            }) {
                                Text(department.name)
                            }
                        }
                    } label: {
                        Label(selectedDepartment?.name ?? "Department", systemImage: "building.2.crop.circle.fill")
                            .accessibilityLabel("Select Department")
                            .accessibilityHint("Tap to select a department")
                    }
                    Spacer()
                    
                    Button(action: {
                        showSearch.toggle()
                    }) {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                    .accessibilityLabel("Search")
                    .accessibilityHint("Tap to search for doctors or departments")
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                if let selectedSearchResult = selectedSearchResult {
                    switch selectedSearchResult.type {
                    case .doctor:
                        if case .doctor(let doctor) = selectedSearchResult.item {
                            DoctorRow(doctor: doctor, expanded: true).environmentObject(booking)
                                .accessibilityLabel("Doctor: \(doctor.name)")
                        }
                    case .department:
                        if case .department(let department) = selectedSearchResult.item {
                            DoctorsList(departmentId: department.id).environmentObject(booking)
                                .accessibilityLabel("Doctors list for department: \(department.name)")
                        }
                    }
                } else if let selectedDepartment = selectedDepartment {
                    DoctorsList(departmentId: selectedDepartment.id).environmentObject(booking)
                        .id(selectedDepartment.id)
                        .accessibilityLabel("Doctors list for department: \(selectedDepartment.name)")
                } else {
                    VStack {
                        Text("Select a department or use search to find doctors")
                            .foregroundColor(.gray)
                            .padding()
                            .accessibilityLabel("Select a department or use search to find doctors")
                    }
                }
            }
        }
        .navigationTitle("Browse Appointments")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: fetchDepartments)
        .sheet(isPresented: $showSearch) {
            AppointmentSearch(selectedSearchResult: $selectedSearchResult, selectedDepartment: $selectedDepartment, showSearch: $showSearch)
                .accessibilityLabel("Appointment Search")
                .accessibilityHint("Search for doctors or departments")
        }
        .toolbar {
            NavigationLink(destination: AppointmentBooking().environmentObject(booking)) {
                Text("Proceed")
                    .accessibilityLabel("Proceed")
                    .accessibilityHint("Tap to proceed to booking")
            }
            .disabled(booking.selectedSlot == nil)
        }
        .errorAlert(errorAlertMessage: errorAlertMessage)
    }
    
    private func fetchDepartments() {
        Task {
            do {
                let fetchedDepartments = try await Department.fetchAll()
                departments = fetchedDepartments
            } catch {
                errorAlertMessage.title = "Departments unable to load"
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
}

#Preview {
    AppointmentBrowseView()
}

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
                    Picker("Departments", selection: $selectedDepartment) {
                        ForEach(departments) { department in
                            Text(department.name).tag(department as Department?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedDepartment) {
                        selectedSearchResult = nil
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showSearch.toggle()
                    }) {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                if let selectedSearchResult = selectedSearchResult {
                    switch selectedSearchResult.type {
                    case .doctor:
                        if case .doctor(let doctor) = selectedSearchResult.item {
                            DoctorRow(doctor: doctor).environmentObject(booking)
                                .padding(.horizontal)
                        }
                    case .department:
                        if case .department(let department) = selectedSearchResult.item {
                            DoctorsList(departmentId: department.id).environmentObject(booking)
                        }
                    }
                } else if let selectedDepartment = selectedDepartment {
                    DoctorsList(departmentId: selectedDepartment.id).environmentObject(booking)
                } else {
                    VStack {
                        Text("Select a department or use search to find doctors")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
            }
        }
        .navigationTitle("Browse Appointments")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: fetchDepartments)
        .sheet(isPresented: $showSearch) {
            AppointmentSearch(selectedSearchResult: $selectedSearchResult, selectedDepartment: $selectedDepartment, showSearch: $showSearch)
        }
        .toolbar {
            NavigationLink(destination: AppointmentBooking().environmentObject(booking)) {
                Text("Proceed")
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

//
//  AppointmentBrowseView.swift
//  iHospital
//
//  Created by Adnan Ahmad on 05/07/24.
//

import SwiftUI

struct AppointmentBrowseView: View {
    @State private var selectedDate: Date = Date()
    @State private var showSearch = false
    @State private var selectedSearchResult: Search?
    @State private var selectedDepartment: Department? = nil
    
    @State var departments: [Department] = []
    
    @StateObject private var errorAlertMessage = ErrorAlertMessage()

    var body: some View {
        VStack {
            HorizontalCalenderView(selectedDate: $selectedDate)
            Divider()
            
            HStack {
                if departments.isEmpty {
                    ProgressView()
                } else {
                    Picker("Departments", selection: $selectedDepartment) {
                        ForEach(departments) { department in
                            Text(department.name).tag(department as Department?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
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
                VStack {
                    Text(selectedSearchResult.name)
                        .font(.title2)
                        .padding()
                    
                    Text(selectedSearchResult.icon)
                        .font(.title3)
                        .padding(.bottom)
                }
            }
            
            Spacer()
        }
        .navigationTitle("Browse Appointments")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: fetchDepartments)
        .sheet(isPresented: $showSearch) {
            AppointmentSearch(selectedSearchResult: $selectedSearchResult, showSearch: $showSearch)
        }
    }
    
    private func fetchDepartments() {
        Task {
            do {
                let departments = try await Department.fetchAll()
                self.departments = departments
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

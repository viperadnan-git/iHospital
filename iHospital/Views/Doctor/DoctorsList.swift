//
//  DoctorsList.swift
//  iHospital
//
//  Created by Adnan Ahmad on 07/07/24.
//

import SwiftUI

struct DoctorsList: View {
    var departmentId: UUID
    @Binding var expandedDoctorId: UUID?
    
    @State private var doctors: [Doctor] = []
    @State private var isLoading = true
    @StateObject private var errorAlertMessage = ErrorAlertMessage()
    
    @EnvironmentObject var booking: BookingViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            if isLoading {
                ProgressView()
                    .padding()
            } else if doctors.isEmpty {
                Text("No doctors available for this department.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ForEach(doctors, id: \.userId) { doctor in
                    DoctorRow(doctor: doctor, expandedDoctorId: $expandedDoctorId)
                        .environmentObject(booking)
                }
            }
        }
        .onAppear(perform: fetchDoctors)
        .errorAlert(errorAlertMessage: errorAlertMessage)
    }
    
    private func fetchDoctors() {
        Task {
            defer {
                isLoading = false
            }
            
            do {
                print("fetching doctors for department \(departmentId)")
                let fetchedDoctors = try await Doctor.fetchDepartmentWise(departmentId: departmentId)
                doctors = fetchedDoctors
            } catch {
                print(error)
                errorAlertMessage.title = "Error fetching doctors"
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
}

#Preview {
    DoctorsList(departmentId: Department.defaultDepartment.id, expandedDoctorId: .constant(nil))
}

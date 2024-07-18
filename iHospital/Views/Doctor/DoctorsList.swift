import SwiftUI

struct DoctorsList: View {
    var departmentId: UUID
    
    @State private var doctors: [Doctor] = []
    @State private var isLoading = true
    @StateObject private var errorAlertMessage = ErrorAlertMessage()
    
    @EnvironmentObject var booking: BookingViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            if isLoading {
                ProgressView()
                    .padding()
                    .accessibilityLabel("Loading doctors")
            } else if doctors.isEmpty {
                Text("No doctors available for this department.")
                    .foregroundColor(.gray)
                    .padding()
                    .accessibilityLabel("No doctors available for this department.")
            } else {
                ForEach(doctors, id: \.userId) { doctor in
                    DoctorRow(doctor: doctor)
                        .environmentObject(booking)
                        .accessibilityLabel("Doctor: \(doctor.name)")
                }
            }
        }
        .onAppear(perform: fetchDoctors)
        .errorAlert(errorAlertMessage: errorAlertMessage)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Doctors list for department")
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
    DoctorsList(departmentId: Department.defaultDepartment.id)
}

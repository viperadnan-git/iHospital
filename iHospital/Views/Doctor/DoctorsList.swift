import SwiftUI

struct DoctorsList: View {
    var departmentId: UUID

    @State private var doctors: [Doctor] = []
    @State private var isLoading = true
    @StateObject private var errorAlertMessage = ErrorAlertMessage()
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .padding()
            } else if doctors.isEmpty {
                Text("No doctors available for this department.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ForEach(doctors, id: \.userId) { doctor in
                    DoctorRow(doctor: doctor)
                }
            }
        }.padding(.horizontal)
            .onAppear {
                fetchDoctors()
            }
            .errorAlert(errorAlertMessage: errorAlertMessage)
    }
    
    private func fetchDoctors() {
        Task {
            defer {
                isLoading = false
            }
            
            do {
                let fetchedDoctors = try await Doctor.fetchDepartmentWise(departmentId: departmentId)
                doctors = fetchedDoctors
            } catch {
                errorAlertMessage.title = "Error fetching doctors"
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
}

#Preview {
    DoctorsList(departmentId: Department.defaultDepartment.id)
}

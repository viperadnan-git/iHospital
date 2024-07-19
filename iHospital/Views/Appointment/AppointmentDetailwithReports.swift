import SwiftUI

struct AppointmentDetailwithReports: View {
    var appointment: Appointment
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Doctor Information
                HStack(alignment: .center) {
                    Image("DoctorImage")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .padding(.trailing, 4)
                        .accessibilityLabel("Doctor's image")
                    
                    VStack(alignment: .leading) {
                        Text(appointment.doctor.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .accessibilityLabel("Doctor's name: \(appointment.doctor.name)")
                        Text(appointment.doctor.experienceSince.ago)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .accessibilityLabel("Experience: \(appointment.doctor.experienceSince.ago)")
                    }
                    Spacer()
                }
                .padding(.bottom, 10)
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Image(systemName: "person")
                            .foregroundColor(.accentColor)
                            .accessibilityHidden(true)
                        Text(appointment.patient.name)
                            .accessibilityLabel("Patient's name: \(appointment.patient.name)")
                    }
                    
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.accentColor)
                            .accessibilityHidden(true)
                        Text("\(appointment.date, style: .date) at \(appointment.date, style: .time)")
                            .accessibilityLabel("Appointment date and time: \(appointment.date, style: .date) at \(appointment.date, style: .time)")
                    }
                    
                    HStack {
                        Image(systemName: "info.square.fill")
                            .foregroundColor(.accentColor)
                            .accessibilityHidden(true)
                        Text(appointment.appointmentStatus.rawValue.capitalized)
                            .accessibilityLabel("Status: \(appointment.appointmentStatus.rawValue.capitalized)")
                        Spacer()
                        Text((appointment.doctor.fee).formatted(.currency(code: "INR")))
                            .font(.title3)
                            .accessibilityLabel("Fee: \((appointment.doctor.fee).formatted(.currency(code: "INR")))")
                    }
                }
                .padding(.top, 10)
                
                // Prescriptions
                Text("Prescriptions")
                    .font(.title3)
                    .fontWeight(.bold)
                    .accessibilityLabel("Prescriptions")
                
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 100)
                    .foregroundColor(Color.gray.opacity(0.3))
                    .overlay(
                        Text("Prescriptions Placeholder")
                            .foregroundColor(.gray)
                            .accessibilityLabel("Prescriptions Placeholder")
                    )
                    .padding(.bottom, 10)
                
                Text("Lab Tests")
                    .font(.title3)
                    .fontWeight(.bold)
                    .accessibilityLabel("Lab Tests")
                
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 100)
                    .foregroundColor(Color.gray.opacity(0.3))
                    .overlay(
                        Text("Lab Tests Placeholder")
                            .foregroundColor(.gray)
                            .accessibilityLabel("Lab Tests Placeholder")
                    )
            }
            .padding()
            .navigationTitle("Next Appointment")
            .navigationBarTitleDisplayMode(.inline)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    AppointmentDetailwithReports(appointment: Appointment.sample)
}

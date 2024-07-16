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
                       
                       VStack(alignment: .leading) {
                           Text(appointment.doctor.name)
                               .font(.title)
                               .fontWeight(.bold)
                           Text(appointment.doctor.experienceSince.ago)
                               .font(.subheadline)
                               .foregroundColor(.gray)
                       }
                       Spacer()
                   }
                   .padding(.bottom, 10)
                   
                   VStack(alignment: .leading, spacing: 5) {
                       HStack {
                           Image(systemName: "person")
                               .foregroundColor(.accentColor)
                           Text(appointment.patient.name)
                       }
                       
                       HStack {
                           Image(systemName: "calendar")
                               .foregroundColor(.accentColor)
                           Text("\(appointment.date, style: .date) at \(appointment.date, style: .time)")
                       }
                       
                       HStack {
                           Image(systemName: "info.square.fill")
                               .foregroundColor(.accentColor)
                           Text(appointment.appointmentStatus.rawValue.capitalized)
                           Spacer()
                           Text((appointment.doctor.fee).formatted(.currency(code: "INR")))
                               .font(.title3)
                       }
                   }
                   .padding(.top, 10)
                   
                   // Prescriptions
                   Text("Prescriptions")
                       .font(.title3)
                       .fontWeight(.bold)
                   
                   RoundedRectangle(cornerRadius: 8)
                       .frame(height: 100)
                       .foregroundColor(Color.gray.opacity(0.3))
                       .overlay(
                           Text("Prescriptions Placeholder")
                               .foregroundColor(.gray)
                       )
                       .padding(.bottom, 10)
                   
                   Text("Lab Tests")
                       .font(.title3)
                       .fontWeight(.bold)
                   
                   RoundedRectangle(cornerRadius: 8)
                       .frame(height: 100)
                       .foregroundColor(Color.gray.opacity(0.3))
                       .overlay(
                           Text("Lab Tests Placeholder")
                               .foregroundColor(.gray)
                       )
               }
               .padding()
               .navigationTitle("Next Appointment")
               .navigationBarTitleDisplayMode(.inline)
           }
       }
   }
#Preview {
    AppointmentDetailwithReports(appointment: Appointment.sample)
}

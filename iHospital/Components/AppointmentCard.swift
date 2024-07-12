//
//  AppointmentCard.swift
//  iHospital
//
//  Created by Adnan Ahmad on 05/07/24.
//

import SwiftUI

struct AppointmentCard: View {
    var appointment: Appointment
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("DoctorImage")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 48)
                    .padding(.trailing, 4)
                
                VStack(alignment: .leading) {
                    Text(appointment.doctor.name)
                        .font(.title3)
                    Text(appointment.doctor.experienceSince.yearsSinceString)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text((appointment.doctor.settings?.fee ?? 799).formatted(.currency(code: "INR"))).font(.title3)
            }
           

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
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    AppointmentCard(
        appointment: Appointment.sample
    )
}

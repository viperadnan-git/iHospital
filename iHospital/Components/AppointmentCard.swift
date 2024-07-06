//
//  AppointmentCard.swift
//  iHospital
//
//  Created by Adnan Ahmad on 05/07/24.
//

import SwiftUI

struct AppointmentCard: View {
    var doctorName: String
    var consultationType: String
    var appointmentDate: String
    var appointmentTime: String
    var doctorImage: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(doctorImage)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .padding(.trailing, 10)
                
                VStack(alignment: .leading) {
                    Text(doctorName)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    Text(consultationType)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .padding()
            
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.white)
                Text(appointmentDate)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "clock")
                    .foregroundColor(.white)
                Text(appointmentTime)
                    .foregroundColor(.white)
            }.bold()
            .padding([.horizontal, .bottom])
            .background(Color.accentColor)
            .cornerRadius(10)
        }
        .background(Color.accentColor)
        .cornerRadius(10)
    }
}

#Preview {
    AppointmentCard(
        doctorName: "Dr. Alana Rueter",
        consultationType: "Dentist Consultation",
        appointmentDate: "Monday, 26 July",
        appointmentTime: "09:00 - 10:00",
        doctorImage: "doctor_image"
    )
}

//
//  AppointmentButton.swift
//  iHospital
//
//  Created by Shoaib Akhtar on 04/07/24.
//

import SwiftUI

struct AppointmentButton: View {
    var imageName: String
    var doctorName: String
    var specialty: String
    var appointmentDate: String
    var appointmentTime: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(imageName)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .padding(.trailing, 15)
                
                VStack(alignment: .leading) {
                    Text(doctorName)
                        .font(.headline)
                        .foregroundColor(.black)
                    Text(specialty)
                        .foregroundColor(.black)
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.black)
                        Text(appointmentDate)
                            .foregroundColor(.black)
                    }
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.black)
                        Text(appointmentTime)
                            .foregroundColor(.black)
                    }
                }
                Spacer()
            }
            .padding()
            .background(Color.accentColor.opacity(0.3))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
}

struct AppointmentButton_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentButton(
            imageName: "doctor_image",
            doctorName: "Dr. Darlene Robertson",
            specialty: "Dental Specialist",
            appointmentDate: "Monday, May 12",
            appointmentTime: "11:00 - 12:00 AM",
            action: {
                // Handle action
            }
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}


//
//  AppointmentCard.swift
//  iHospital
//
//  Created by Adnan Ahmad on 05/07/24.
//

import SwiftUI

struct AppointmentCard: View {
    var appointment: Appointment
    @State private var selectedAction: String = "Select Action"
    @State private var isCancelAlertPresented: Bool = false
    @State private var navigateToReschedule: Bool = false
    
    let actions = ["Reschedule Appointment", "Cancel Appointment"]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                ProfileImage(userId: appointment.doctor.userId.uuidString)
                    .frame(width: 50, height: 50)
                    .padding(.trailing, 4)
                    .accessibilityLabel("Doctor's profile picture")
                
                VStack(alignment: .leading) {
                    Text(appointment.doctor.name)
                        .font(.title3)
                        .accessibilityLabel("Doctor: \(appointment.doctor.name)")
                    AppointmentStatusIndicator(status: appointment.appointmentStatus)
                    Spacer()
                }
                Spacer()
            }
            
            HStack {
                Image(systemName: "person")
                    .foregroundColor(.accentColor)
                    .accessibilityHidden(true)
                Text(appointment.patient.name)
                    .accessibilityLabel("Patient: \(appointment.patient.name)")
            }
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.accentColor)
                    .accessibilityHidden(true)
                Text("\(appointment.date, style: .date) at \(appointment.date, style: .time)")
                    .accessibilityLabel("Appointment date and time: \(appointment.date, style: .date) at \(appointment.date, style: .time)")
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

struct AppointmentStatusIndicator: View {
    let status: AppointmentStatus

    var body: some View {
        HStack {
            Circle()
                .fill(status.color)
                .frame(width: 10, height: 10)
                .accessibilityHidden(true)
            Text(status.rawValue.capitalized)
                .font(.footnote)
                .accessibilityLabel("Status: \(status.rawValue.capitalized)")
        }
    }
}

#Preview {
    AppointmentCard(
        appointment: Appointment.sample
    )
}

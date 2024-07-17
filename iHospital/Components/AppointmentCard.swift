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
                Image(systemName: "person.crop.circle.fill")
                    .font(.largeTitle)
                    .padding(.trailing, 4)
                
                VStack(alignment: .leading) {
                    Text(appointment.doctor.name)
                        .font(.title3)
                    AppointmentStatusIndicator(status: appointment.appointmentStatus)
                    Spacer()
                }
                Spacer()
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
            Text(status.rawValue.capitalized)
                .font(.footnote)
        }
    }
}

#Preview {
    AppointmentCard(
        appointment: Appointment.sample
    )
}

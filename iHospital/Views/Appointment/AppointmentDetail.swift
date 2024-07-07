//
//  AppointmentDetail.swift
//  iHospital
//
//  Created by Adnan Ahmad on 07/07/24.
//

import SwiftUI

struct AppointmentDetailView: View {
    let appointment: Appointment
    
    var body: some View {
        VStack {
            Text("Appointment Details")
                .font(.largeTitle)
                .padding()
            
            Text("Doctor: \(appointment.doctor.name)")
                .font(.title2)
                .padding()
            
            Text("Patient: \(appointment.patient.name)")
                .font(.title2)
                .padding()
            
            Text("Date: \(appointment.date, style: .date) at \(appointment.date, style: .time)")
                .font(.title2)
                .padding()
            
            Text("Payment Status: \(appointment.paymentStatus.rawValue.capitalized)")
                .font(.title2)
                .padding()
            
            Text("Appointment Status: \(appointment.appointmentStatus.rawValue)")
                .font(.title2)
                .padding()
            
            Spacer()
        }
        .navigationTitle("Appointment Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AppointmentDetailView(appointment: Appointment.sample)
}

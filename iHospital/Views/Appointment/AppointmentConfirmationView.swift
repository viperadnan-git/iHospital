//
//  AppointmentConfirmationView.swift
//  iHospital
//
//  Created by Adnan Ahmad on 07/07/24.
//

import SwiftUI

struct AppointmentConfirmationView: View {
    let appointment: Appointment
    
    @Environment(\.navigation) private var navigation
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "checkmark.seal.fill")
                .foregroundStyle(.green)
                .font(.system(size: 100))
                .accessibilityHidden(true)
            
            Text("Appointment Confirmed")
                .font(.title)
                .fontWeight(.bold)
                .padding()
                .accessibilityLabel("Appointment Confirmed")
            
            Text("\(appointment.patient.firstName)'s appointment with \(appointment.doctor.name) has been confirmed for \(appointment.date, style: .date) at \(appointment.date, style: .time).")
                .multilineTextAlignment(.center)
                .padding()
                .accessibilityLabel("\(appointment.patient.firstName)'s appointment with \(appointment.doctor.name) has been confirmed for \(appointment.date, style: .date) at \(appointment.date, style: .time).")
            
            Spacer()
            
            Button(action: {
                // Dismiss the view to go back to home
                navigation.path = NavigationPath()
            }) {
                Text("Done")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .accessibilityLabel("Done")
                    .accessibilityHint("Tap to return to the home screen")
            }
            .padding()
        }
        .navigationTitle("Appointment Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    AppointmentConfirmationView(appointment: Appointment.sample)
}

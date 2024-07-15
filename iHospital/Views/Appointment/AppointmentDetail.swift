//
//  AppointmentDetail.swift
//  iHospital
//
//  Created by Adnan Ahmad on 07/07/24.
//

import SwiftUI

struct AppointmentDetailView: View {
    let appointment: Appointment
    
    @Environment(\.navigation) private var navigation
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "checkmark.seal.fill")
                .foregroundStyle(.green)
                .font(.system(size: 100))

            Text("Appointment Confirmed")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Text("\(appointment.patient.firstName)'s appointment with \(appointment.doctor.name) has been confirmed for \(appointment.date, style: .date) at \(appointment.date, style: .time).")
                .multilineTextAlignment(.center)
                .padding()

            
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
            }.padding()
        }
        .navigationTitle("Appointment Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    AppointmentDetailView(appointment: Appointment.sample)
}

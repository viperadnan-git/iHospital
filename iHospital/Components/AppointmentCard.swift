//
//  AppointmentCard.swift
//  iHospital
//
//  Created by Adnan Ahmad on 05/07/24.
//

import SwiftUI

struct AppointmentCard: View {
    var appointment: Appointment
    @State private var isAlertPresented: Bool = false
    @State private var isCancelAlertPresented: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
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
            
                HStack(alignment: .center) {
//                    Image(systemName: "circle.fill")
//                        .foregroundColor(.green)
//                    Text("Upcoming")
                    Button(action: {
                        isAlertPresented = true
                    }) {
                        Image(systemName: "ellipsis.circle")
                        
                    }
                    .alert("Update your appointment",isPresented: $isAlertPresented) {
                            NavigationLink(destination: RescheduleAppointment()){
                            Button("Reschedule Appointment"){
                                
                            }
                        }
                        Button("Cancel Appointment", role: .destructive){
                            isCancelAlertPresented = true
                        }
                        
                    }
                    .alert("Are you sure you want to cancel your appointment?", isPresented: $isCancelAlertPresented){
                        Button("Confirm"){
                            
                        }
                        Button("Go back"){
                            
                        }
                    }
                }
                
                
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
                Spacer()
                Text((appointment.doctor.settings?.fee ?? 799).formatted(.currency(code: "INR"))).font(.title3)
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

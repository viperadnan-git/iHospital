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
                     Menu {
                         ForEach(actions, id: \.self) { action in
                             Button(action: {
                                 selectedAction = action
                                 if action == "Cancel Appointment" {
                                     isCancelAlertPresented = true
                                 } else if action == "Reschedule Appointment" {
                                     navigateToReschedule = true
                                 }
                             }) {
                                 Text(action)
                             }
                         }
                     } label: {
                         Image(systemName: "ellipsis.circle")
                     }
                     .alert(isPresented: $isCancelAlertPresented) {
                         Alert(
                             title: Text("Are you sure you want to cancel your appointment?"),
                             primaryButton: .destructive(Text("Confirm")) {
                                 // Handle appointment cancellation
                             },
                             secondaryButton: .cancel(Text("Go back"))
                         )
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
         .background(
             NavigationLink(destination: RescheduleAppointment(), isActive: $navigateToReschedule) {
                 EmptyView()
             }
         )
     }
 }
#Preview {
    AppointmentCard(
        appointment: Appointment.sample
    )
}

//
//  AppointmentBooking.swift
//  iHospital
//
//  Created by Adnan Ahmad on 07/07/24.
//

import SwiftUI

struct AppointmentBooking: View {
    @EnvironmentObject var booking: BookingViewModel
    
    var body: some View {
        VStack {
            if let doctor = booking.doctor, let bookingDate = booking.selectedSlot {
                Text("Booking with \(doctor.name)")
                    .font(.largeTitle)
                    .padding()
                
                Text("Appointment Date: \(bookingDate, style: .date) at \(bookingDate, style: .time)")
                    .font(.title2)
                    .padding()
                
                // Additional booking details and confirmation button
                Button(action: {
                    // Implement booking confirmation logic
                }) {
                    Text("Confirm Booking")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
            }
        }
        .navigationTitle("Confirm Booking")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AppointmentBooking()
}

//
//  BedBookingView.swift
//  iHospital
//

import SwiftUI

struct BedBookingView: View {
    @State private var selectedSegment = 0
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 8) {
                    // Bed Booking Section
                    NavigationLink(destination: BedBookingDetailsView()) {
                        HStack {
                            Text("Book Now")
                                .padding(12)
                                .foregroundColor(.white)
                                .background(Color.accentColor)
                                .cornerRadius(8)
                                .accessibilityLabel("Book Now")
                                .accessibilityHint("Navigates to the bed booking details screen")
                            
                            Image("hospitalBed")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 160, height: 150)
                                .padding()
                                .accessibilityHidden(true)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(Color(uiColor: .systemGray6))
                                .frame(width: 361)
                        )
                        .padding()
                    }
                    
                    // Segment Picker
                    Picker("Appointments", selection: $selectedSegment) {
                        Text("Booked").tag(0)
                        Text("Past Bookings").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .accessibilityLabel("Appointments")
                    .accessibilityHint("Switch between booked and past bookings")
                    
                    // Booked Beds Cards
                    VStack(spacing: 8) {
                        BookedBedsCard()
                        BookedBedsCard()
                        BookedBedsCard()
                    }
                    .padding(.horizontal, 16)
                    
                    Spacer()
                }
                .padding(.top, 0) // Remove extra top padding
            }
            .navigationTitle("Bed Booking")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    BedBookingView()
}

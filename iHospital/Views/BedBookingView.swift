//
//  BedBooking.swift
//  iHospital
//

import SwiftUI

struct BedBookingView: View {
    @State private var selectedSegment = 0
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 8) {
                    NavigationLink(destination: BedBookingDetailsView()) {
                        HStack {
                            NavigationLink(destination: BedBookingDetailsView()) {
                                Text("Book Now")
                                    .padding(12)
                                    .foregroundColor(.white)
                                    .background(Color.accentColor)
                                    .cornerRadius(8)
                            }
                            
                            // Image
                            Image("hospitalBed")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 160, height: 150)
                                .padding()
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(Color(uiColor: .systemGray6))
                                //.shadow(radius: 5, x: 4, y: 4)
                                .frame(width: 361)
                        )
                        .padding()
                    }
                    Picker("Appointments", selection: $selectedSegment) {
                        Text("Booked").tag(0)
                        Text("Past Bookings").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    // populating with component / replace this with database
                    BookedBedsCard()
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    
                    BookedBedsCard()
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    BookedBedsCard()
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
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

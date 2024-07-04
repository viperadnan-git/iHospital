//
//  DashboardView.swift
//  iHospital
//
//  Created by Shoaib Akhtar on 03/07/24.
//

import SwiftUI

struct DashboardView: View {
    @State private var text: String = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("What do you feel ?")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    ImageButton(imageName: "Image") {
                        // Handle image button action
                    }
                    
                    Text("Next Appointment")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    AppointmentButton(
                        imageName: "doctor_image",
                        doctorName: "Dr. Darlene Robertson",
                        specialty: "Dental Specialist",
                        experience: "3 Years",
                        appointmentDate: "Monday, May 12",
                        appointmentTime: "11:00 - 12:00 AM",
                        action: {
                            // Handle appointment button action
                        }
                    )
                    
                    
                    Text("Additional features")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    GeometryReader { geometry in
                        HStack(spacing: 20) {
                            NavigationLink(destination: BedBookingView()) {
                                FeatureButton(imageName: "bed.double.fill", title: "Bed Booking")
                                    .frame(width: (geometry.size.width / 3) - 20)
                            }
                            NavigationLink(destination: AppointmentBookingView()) {
                                FeatureButton(imageName: "calendar.badge.plus", title: "Appointment")
                                    .frame(width: (geometry.size.width / 3) - 20)
                            }
                            NavigationLink(destination: MedicalInformationView()) {
                                FeatureButton(imageName: "doc.text.fill", title: "Medical Information")
                                    .frame(width: (geometry.size.width / 3) - 20)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 150)
                }
                .padding(.top)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    VStack(alignment: .leading) {
                        Text("Hello, \(User.shared?.firstName ?? "Unknown") 👋")
                            .font(.system(size: 30))
                            .fontWeight(.bold)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ProfileSwitchingView()) {
                        Image(systemName: "person.circle")
                            .font(.title)
                    }
                }
                
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .tabItem {
            Image(systemName: "person.fill")
            Text("Dashboard")
        }
    }
}

#Preview {
    DashboardView()
}


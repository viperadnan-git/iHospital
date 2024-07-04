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
                  /*
                    HStack {
                        Text("Hello, \(User.shared?.firstName ?? "Unknown") 👋")
                            .font(.system(size: 30))
                            .fontWeight(.bold)
                        
                        Spacer()
                        Button(action: {
                            // Handle image button action
                        }) {
                            Image(systemName: "person.circle")
                                .font(.title)
                        }
                    }
                    .padding(.horizontal)
                   */
                    Text("What do you feel ?")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                  
                    
                    ZStack(alignment: .leading) {
                        if text.isEmpty {
                            Text("      Health issue or doctor")
                                .foregroundColor(.black)
                                .padding(.leading, 8)
                        }
                        TextField("", text: $text)
                            .padding()
                            .foregroundColor(.black)
                            .background(Color.accentColor.opacity(0.3))
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    
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
                                                FeatureButton(imageName: "bed.double.fill", title: "Bed Booking")
                                                    .frame(width: (geometry.size.width / 3) - 20)
                                                
                                                FeatureButton(imageName: "calendar.badge.plus", title: "Appointment")
                                                    .frame(width: (geometry.size.width / 3) - 20)
                                                
                                                FeatureButton(imageName: "doc.text.fill", title: "Medical Information")
                                                    .frame(width: (geometry.size.width / 3) - 20)
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
                                        .font(.system(size: 24))
                                        .fontWeight(.bold)
                                }
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    // Handle image button action
                                }) {
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

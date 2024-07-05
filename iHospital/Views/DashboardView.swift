//
//  DashboardView.swift
//  iHospital
//
//  Created by Shoaib Akhtar on 03/07/24.
//

import SwiftUI

struct DashboardView: View {
    @State private var text: String = ""
    @State private var profiles = ["Vicky", "Shoaib"] // Sample profiles, replace with actual data
    @State private var showProfileSheet = false
    @State private var showLogoutAlert = false
    
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
                                FeatureButton(imageName: "Bed Booking", title: "Bed Booking")
                                    .frame(width: (geometry.size.width / 3) - 20)
                            }
                            NavigationLink(destination: AllAppointmentsView()) {
                                FeatureButton(imageName: "Appointments", title: "Appointment")
                                    .frame(width: (geometry.size.width / 3) - 20)
                            }
                            NavigationLink(destination: MedicalInformationView()) {
                                FeatureButton(imageName: "Medical information", title: "Medical Information")
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
                    Image(systemName: "person.circle")
                        .font(.title)
                        .contextMenu {
                            ForEach(profiles, id: \.self) { profile in
                                Button(action: {
                                    // Switch to this profile
                                }) {
                                    Text(profile)
                                }
                            }
                            
                            Button(action: {
                                showProfileSheet.toggle()
                            }) {
                                Text("Add New Profile")
                            }
                            
                            Divider()
                            
                            Button(action: {
                                showLogoutAlert = true
                            }) {
                                HStack {
                                    Spacer()
                                    Text("Logout")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.red)
                                        .cornerRadius(8)
                                    Spacer()
                                }
                            }
                        }
                }
            }
            .alert(isPresented: $showLogoutAlert) {
                Alert(
                    title: Text("Logout"),
                    message: Text("Are you sure you want to logout?"),
                    primaryButton: .destructive(Text("Logout")) {
                        Task {
                            do {
                                try await User.logOut()
                            } catch {
                                // Handle logout error
                            }
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .sheet(isPresented: $showProfileSheet) {
            // Sheet content for adding a new profile
            AddProfileView(profiles: $profiles)
        }
        .tabViewStyle(PageTabViewStyle())
        .tabItem {
            Image(systemName: "person.fill")
            Text("Dashboard")
        }
    }
}

struct AddProfileView: View {
    @Binding var profiles: [String]
    
    var body: some View {
        NavigationView {
            // Directly navigate to UserDetailsView when Add Profile is tapped
            UserDetailsView()
                .navigationBarTitle("Add New Profile", displayMode: .inline)
                .navigationBarItems(trailing: Button("Done") {
                    // Close the sheet if needed
                })
        }
    }
}

#Preview {
    DashboardView()
}

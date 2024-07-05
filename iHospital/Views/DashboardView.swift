//
//  DashboardView.swift
//  iHospital
//
//  Created by Shoaib Akhtar on 03/07/24.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var patientViewModel: PatientViewModel
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
                    
                    AppointmentCard(
                        doctorName: "Dr. Alana Rueter",
                        consultationType: "Dentist Consultation",
                        appointmentDate: "Monday, 26 July",
                        appointmentTime: "09:00 - 10:00",
                        doctorImage: "doctor_image"
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ProfileView().environmentObject(patientViewModel)) {
                        Image(systemName: "person.circle")
                            .font(.title)
                    }
                }
            }
            .navigationTitle("Hello Adnan")
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
    }
}

#Preview {
    DashboardView().environmentObject(PatientViewModel())
}

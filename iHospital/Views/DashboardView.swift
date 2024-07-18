//
//  DashboardView.swift
//  iHospital
//
//  Created by Shoaib Akhtar on 03/07/24.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var patientViewModel: PatientViewModel
    @EnvironmentObject private var authViewModel: AuthViewModel
    @StateObject private var navigation = Navigation()
    @State private var showAppointmentDetail = false
    @StateObject private var viewModel = AppointmentViewModel()
    
    var body: some View {
        NavigationStack(path: $navigation.path) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Appointment Booking Section
                    NavigationLink(destination: AppointmentBrowseView()) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Need an Appointment")
                                    .multilineTextAlignment(.leading)
                                    .font(.title2)
                                    .foregroundColor(Color(.label))
                                    .fontWeight(.bold)
                                
                                Spacer()
                                NavigationLink(destination: AppointmentBrowseView()) {
                                    Text("Book Now")
                                        .padding(12)
                                        .foregroundColor(.white)
                                        .background(Color.accentColor)
                                        .cornerRadius(8)
                                        .accessibilityLabel("Book Now")
                                        .accessibilityHint("Navigates to the appointment booking screen")
                                }
                            }
                            .frame(alignment: .leading)
                            .padding()
                            
                            Image("Online doctor")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaledToFit()
                        }
                        .background(Color(uiColor: .systemGray6))
                        .cornerRadius(8)
                        .accessibilityLabel("Need an Appointment")
                        .accessibilityHint("Tap to book an appointment")
                    }
                    
                    // Loading Indicator for Appointments
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        // Next Appointment Section
                        if let nextAppointment = viewModel.upcomingAppointments.first {
                            Text("Next Appointment")
                                .font(.title3)
                                .fontWeight(.bold)
                            
                            NavigationLink(destination: AppointmentDetailView(appointment: nextAppointment).environmentObject(viewModel)) {
                                AppointmentCard(appointment: nextAppointment)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                    .foregroundColor(Color(.label))
                                    .accessibilityLabel("Next Appointment")
                                    .accessibilityHint("Shows details of your next appointment")
                            }
                        }
                    }
                    
                    // Features Section
                    Text("Features")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    GeometryReader { geometry in
                        HStack(alignment: .top, spacing: 20) {
                            // Bed Booking Feature
                            NavigationLink(destination: BedBookingView()) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(uiColor: .systemGray6))
                                    VStack {
                                        Image(systemName: "bed.double.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.blue)
                                        Spacer()
                                        
                                        Text("Bed Booking")
                                            .font(.headline)
                                    }
                                    .padding()
                                }
                                .frame(width: 170, height: 100)
                                .accessibilityLabel("Bed Booking")
                                .accessibilityHint("Navigates to the bed booking screen")
                            }
                            
                            // Billing Feature
                            NavigationLink(destination: InvoiceListView()) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(uiColor: .systemGray6))
                                    VStack {
                                        Image(systemName: "dollarsign.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.blue)
                                        Spacer()
                                        
                                        Text("Billing")
                                            .font(.headline)
                                    }
                                    .padding()
                                }
                                .frame(width: 170, height: 100)
                                .accessibilityLabel("Billing")
                                .accessibilityHint("Navigates to the billing screen")
                            }
                        }
                        .foregroundColor(Color(.label))
                    }
                    .frame(height: 150)
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ProfileView().environmentObject(patientViewModel)) {
                        ProfileImage(userId: authViewModel.user?.id.uuidString ?? "")
                            .frame(width: 40, height: 40)
                            .accessibilityLabel("Profile")
                            .accessibilityHint("Navigates to your profile")
                    }
                }
            }
            .navigationTitle("Hello \(authViewModel.user?.firstName ?? "Unknown")")
        }
        .environment(\.navigation, navigation)
    }
}

#Preview {
    DashboardView().environmentObject(PatientViewModel())
}

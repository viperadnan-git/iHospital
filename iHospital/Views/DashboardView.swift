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
        NavigationStack(path:$navigation.path) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
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
                    }
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else{
                        
                        if let nextAppointment = viewModel.upcomingAppointments.first {
                            
                            Text("Next Appointment")
                                .font(.title3)
                                .fontWeight(.bold)
                            
                            NavigationLink(destination: AppointmentDetailView(appointment: nextAppointment).environmentObject(viewModel)) {
                                AppointmentCard(appointment: nextAppointment)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                    .foregroundColor(Color(.label))
                            }
                            
                        }
                    }
                    Text("Features")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    GeometryReader { geometry in
                        HStack(alignment: .top, spacing: 20) {
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
                            }
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
                    }
                }
            }
            .navigationTitle("Hello \(authViewModel.user?.firstName ?? "Unknown")")
        }.environment(\.navigation, navigation)
    }
}

#Preview {
    DashboardView().environmentObject(PatientViewModel())
}

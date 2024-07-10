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

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                        HStack{
                            VStack{
                                Text("Need an Appointment")
                                    .multilineTextAlignment(.leading)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color(uiColor: .label))
                                
                                Spacer()
                                NavigationLink(destination: AppointmentBrowseView()){
                                    
                                        Text("Book Now")
                                            .font(.headline)
                                            .foregroundColor(Color(uiColor: .label))
                                            .padding()
                                    
                                    .background(Color.accentColor)
                                    .cornerRadius(8)
                                }
                              
                                Spacer()
                            }
                            .frame(alignment: .leading)
                            .padding()
                            
                            Image("Online doctor").resizable().aspectRatio(contentMode: .fit)
                                .scaledToFit()
                        }
                        .background(Color(uiColor: .systemGray6))
                        .cornerRadius(8)
                        
                        
                    
                    
                    Text("Next Appointment")
                        .font(.title3)
                        .fontWeight(.bold)
                     
                    
                    AppointmentCard(
                        appointment: Appointment.sample
                    )
                    
                    Text("Additional features")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    GeometryReader { geometry in
                        HStack(alignment: .top,spacing: 20) {
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
                            NavigationLink(destination: MedicalInformationView()) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
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
                        Image(systemName: "person.crop.circle.fill")
                            .font(.title)
                    }
                }
            }
            .navigationTitle("Hello \(authViewModel.user?.firstName ?? "Unknown")")
        }
    }
}


#Preview {
    DashboardView().environmentObject(PatientViewModel())
}


















//import SwiftUI
//
//struct DashboardView: View {
//    @State private var text: String = ""
//    @State private var profiles = ["Vicky", "Shoaib"] // Sample profiles, replace with actual data
//    @State private var showProfileSheet = false
//    @State private var showLogoutAlert = false
//
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 20) {
//                    Text("What do you feel ?")
//                        .font(.title3)
//                        .fontWeight(.bold)
//                        .padding(.horizontal)
//
//                    ImageButton(imageName: "Image") {
//                        // Handle image button action
//                    }
//
//                    Text("Next Appointment")
//                        .font(.title3)
//                        .fontWeight(.bold)
//                        .padding(.horizontal)
//
//                    AppointmentButton(
//                        imageName: "doctor_image",
//                        doctorName: "Dr. Darlene Robertson",
//                        specialty: "Dental Specialist",
//                        experience: "3 Years",
//                        appointmentDate: "Monday, May 12",
//                        appointmentTime: "11:00 - 12:00 AM",
//                        action: {
//                            // Handle appointment button action
//                        }
//                    )
//
//                    Text("Additional features")
//                        .font(.title3)
//                        .fontWeight(.bold)
//                        .padding(.horizontal)
//
//                    GeometryReader { geometry in
//                        HStack(spacing: 20) {
//                            NavigationLink(destination: BedBookingView()) {
//                                FeatureButton(imageName: "Bed Booking", title: "Bed Booking")
//                                    .frame(width: (geometry.size.width / 3) - 20)
//                            }
//                            NavigationLink(destination: AllAppointmentsView()) {
//                                FeatureButton(imageName: "Appointments", title: "Appointment")
//                                    .frame(width: (geometry.size.width / 3) - 20)
//                            }
//                            NavigationLink(destination: MedicalInformationView()) {
//                                FeatureButton(imageName: "Medical information", title: "Medical Information")
//                                    .frame(width: (geometry.size.width / 3) - 20)
//                            }
//                        }
//                        .padding(.horizontal)
//                    }
//                    .frame(height: 150)
//                }
//                .padding(.top)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    VStack(alignment: .leading) {
//                        Text("Hello, \(User.shared?.firstName ?? "Unknown") 👋")
//                            .font(.system(size: 30))
//                            .fontWeight(.bold)
//                    }
//                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Image(systemName: "person.circle")
//                        .font(.title)
//
//                        .contextMenu {
//                            ForEach(profiles, id: \.self) { profile in
//                                Button(action: {
//                                    // Switch to this profile
//                                }) {
//                                    Text(profile)
//                                }
//                            }
//
//                            Button(action: {
//                                showProfileSheet.toggle()
//                            }) {
//                                Text("Add New Profile")
//                            }
//                            Divider()
//
//                            Button(role: .destructive, action: {
//                                showLogoutAlert = true
//                            }) {
//                                    Text("Logout")
//                                        .padding()
//                                        .background(Color.red)
//                                        .cornerRadius(8)
//                            }
//                        }
//                }
//            }
//            .alert(isPresented: $showLogoutAlert) {
//                Alert(
//                    title: Text("Logout"),
//                    message: Text("Are you sure you want to logout?"),
//                    primaryButton: .destructive(Text("Logout")) {
//                        Task {
//                            do {
//                                try await User.logOut()
//                            } catch {
//                                // Handle logout error
//                            }
//                        }
//                    },
//                    secondaryButton: .cancel()
//                )
//            }
//        }
//        .sheet(isPresented: $showProfileSheet) {
//            // Sheet content for adding a new profile
//            AddProfileView(profiles: $profiles)
//        }
//        .tabViewStyle(PageTabViewStyle())
//        .tabItem {
//            Image(systemName: "person.fill")
//
//            Text("Dashboard")
//        }
//    }
//}
//
//struct AddProfileView: View {
//    @Binding var profiles: [String]
//
//    var body: some View {
//        NavigationView {
//            // Directly navigate to UserDetailsView when Add Profile is tapped
//            UserDetailsView()
//                .navigationBarTitle("Add New Profile", displayMode: .inline)
//                .navigationBarItems(trailing: Button("Done") {
//                    // Close the sheet if needed
//                })
//        }
//    }
//}
//
//#Preview {
//    DashboardView()
//}

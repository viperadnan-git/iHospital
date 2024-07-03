//
//  DashboardView.swift
//  iHospital
//
//  Created by Adnan Ahmad on 03/07/24.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Hi, Good Morning")
                                .font(.headline)
                            Text("Bruce Wayne")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        Spacer()
                        Image("profile_image")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        Text("Need an appointment?")
                            .font(.title2)
                            .fontWeight(.bold)
                        Button(action: {
                            // Handle book now action
                        }) {
                            Text("Book now")
                                .foregroundColor(.blue)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 2)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    Text("Upcoming Appointment")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    HStack {
                        Image("doctor_image")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        VStack(alignment: .leading) {
                            Text("Dr. Suresh | Orthopaedic")
                                .font(.headline)
                            HStack {
                                Image(systemName: "calendar")
                                Text("27 JUL, 24")
                            }
                            HStack {
                                Image(systemName: "clock")
                                Text("11:00 - 11:30")
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    Text("Additional features")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    HStack(spacing: 20) {
                        FeatureButton(imageName: "bed.double.fill", title: "Book Bed")
                        FeatureButton(imageName: "calendar.badge.plus", title: "Appointment")
                        FeatureButton(imageName: "person.fill", title: "Medical Information")
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            .navigationBarItems(leading: Text("Hello \(User.shared?.firstName ?? "Unknown")")
                                    .font(.largeTitle)
                                    .fontWeight(.bold),
                                trailing: Image(systemName: "person")
            ).padding()
        }
        .tabViewStyle(PageTabViewStyle())
        .tabItem {
            Image(systemName: "house.fill")
            Text("Dashboard")
        }
    }
}

struct FeatureButton: View {
    var imageName: String
    var title: String

    var body: some View {
        VStack {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 40, height: 40)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 2)
            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)
        }
        .frame(width: 100)
    }
}

#Preview {
    DashboardView()
}

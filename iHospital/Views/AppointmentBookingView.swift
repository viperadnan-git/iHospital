//
//  AppointmentBooking.swift
//  iHospital
//
//  Created by Shoaib Akhtar on 04/07/24.
//

import SwiftUI

struct Appointment: Identifiable {
    var id = UUID()
    var doctorName: String
    var specialty: String
    var date: String
    var time: String
    var status: String
}

struct AllAppointmentsView: View {
    @State private var selectedSegment = 0
    @State private var appointments = [
        Appointment(doctorName: "Dr. Darlene Robertson", specialty: "Dental Specialist", date: "Monday, May 12", time: "11:00 - 12:00 AM", status: "Upcoming"),
        Appointment(doctorName: "Dr. John Doe", specialty: "Cardiologist", date: "Tuesday, May 13", time: "09:00 - 10:00 AM", status: "Upcoming"),
        Appointment(doctorName: "Dr. Probeer", specialty: "General Physician", date: "Tuesday, April 13", time: "10:30 - 11:30 AM", status: "Completed"),
        Appointment(doctorName: "Dr. Jane Smith", specialty: "Neurologist", date: "Wednesday, May 14", time: "10:00 - 11:00 AM", status: "Cancel")
    ]
    
    var body: some View {
        VStack {
            Picker("Appointments", selection: $selectedSegment) {
                Text("Upcoming Appointments").tag(0)
                Text("All Appointments").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(filteredAppointments()) { appointment in
                        AppointmentView(appointment: appointment)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(appointmentBorderColor(appointment.status), lineWidth: 2)
                            )
                            .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
        }
        .navigationBarTitle("All Appointments")
    }
    
    private func filteredAppointments() -> [Appointment] {
        if selectedSegment == 0 {
            return appointments.filter { $0.status == "Upcoming" }
        } else {
            return appointments
        }
    }
    
    private func appointmentBorderColor(_ status: String) -> Color {
        switch status {
        case "Upcoming":
            return Color.green
        case "Completed":
            return Color.gray
        default:
            return Color.red
        }
    }
}

struct AppointmentView: View {
    var appointment: Appointment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text(appointment.doctorName)
                        .font(.headline)
                    Text(appointment.specialty)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(statusColor(appointment.status))
                        .frame(width: 10, height: 10)
                    Text(appointment.status)
                        .font(.caption)
                        .foregroundColor(statusColor(appointment.status))
                }
            }
            
            HStack {
                Image(systemName: "calendar")
                Text(appointment.date)
                Spacer()
                Image(systemName: "clock")
                Text(appointment.time)
            }
            .font(.subheadline)
            .foregroundColor(.gray)
        }
        .padding()
    }
    
    private func statusColor(_ status: String) -> Color {
        switch status {
        case "Upcoming":
            return .green
        case "Completed":
            return .gray
        default:
            return .red
        }
    }
}

struct DashboardView1: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: AllAppointmentsView()) {
                    Text("Go to Appointments")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Spacer()
            }
            .navigationBarTitle("Dashboard")
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}

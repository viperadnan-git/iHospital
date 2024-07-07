//
//  DoctorRow.swift
//  iHospital
//
//  Created by Adnan Ahmad on 07/07/24.
//

import SwiftUI

struct DoctorRow: View {
    var doctor: Doctor
    @State private var isExpanded: Bool = false
    @State private var availableSlots: [Date] = []
    @State private var isLoading = false
    @StateObject private var errorAlertMessage = ErrorAlertMessage()
    @State private var navigateToBooking = false
    
    @EnvironmentObject var booking: BookingViewModel
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Image(systemName: "staroflife.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .padding(.trailing, 10)
                        .padding(.top)
                    Spacer()
                }
                
                VStack(alignment: .leading) {
                    Text(doctor.name)
                        .font(.headline)
                    Text("Email: \(doctor.email)")
                        .font(.subheadline)
                    Text("Phone: \(doctor.phoneNumber)")
                        .font(.subheadline)
                    Text("Qualification: \(doctor.qualification)")
                        .font(.subheadline)
                    Text("Experience: \(calculateExperienceYears(from: doctor.experienceSince)) years")
                        .font(.subheadline)
                }
                Spacer()
                
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                        if isExpanded {
                            fetchAvailableSlots()
                        }
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .padding()
                }
            }
            
            if isExpanded {
                if isLoading {
                    ProgressView()
                        .padding()
                }
                else if availableSlots.isEmpty {
                    Text("No slots available for \(booking.forDate.localDate.description)")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    VStack(alignment: .leading) {
                        Text("Available Slots")
                            .font(.headline)
                        ScrollView(.horizontal) {
                            LazyHGrid(rows: Array(repeating: GridItem(.fixed(50), spacing: 10), count: 4), spacing: 10) {
                                ForEach(availableSlots, id: \.self) { slot in
                                    Button(action: {
                                        if booking.selectedSlot == slot {
                                            booking.selectedSlot = nil
                                        } else {
                                            booking.selectedSlot = slot
                                        }
                                    }) {
                                        Text(slot, style: .time)
                                            .padding(8)
                                            .background(booking.selectedSlot == slot ? Color.accentColor : Color.accentColor.opacity(0.2))
                                            .foregroundColor(booking.selectedSlot == slot ? Color.white : Color.primary)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .errorAlert(errorAlertMessage: errorAlertMessage)
        .onChange(of: booking.forDate) {
            if isExpanded {
                fetchAvailableSlots()
            }
        }
    }
    
    private func fetchAvailableSlots() {
        booking.doctor = doctor
        availableSlots = []
        
        Task {
            isLoading = true
            defer {
                isLoading = false
            }
            
            do {
                let settings = try await doctor.getSettings()
                let slots = try await settings.getAvailableTimeSlots(for: booking.forDate)
                availableSlots = slots
            } catch {
                errorAlertMessage.title = "Error fetching slots"
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
    
    private func calculateExperienceYears(from date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date, to: Date())
        return components.year ?? 0
    }
}

#Preview {
    NavigationView {
        DoctorRow(doctor: Doctor.sample)
            .environmentObject(BookingViewModel())
    }
}

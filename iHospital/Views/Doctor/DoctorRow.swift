//
//  DoctorRow.swift
//  iHospital
//
//  Created by Adnan Ahmad on 07/07/24.
//

import SwiftUI

struct DoctorRow: View {
    var doctor: Doctor
    var expanded: Bool = false
    
    @State private var isExpanded: Bool = false
    @State private var availableSlots: [(Date, Bool)] = []
    @State private var isLoading = false
    @State private var navigateToBooking = false
    
    @StateObject private var errorAlertMessage = ErrorAlertMessage(title: "Error")
    @EnvironmentObject var booking: BookingViewModel
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .padding(.trailing, 10)
                        .padding(.top)
                        .foregroundStyle(Color(.systemGray))
                    Spacer()
                }
                
                VStack(alignment: .leading) {
                    Text(doctor.name)
                        .font(.headline)
                    HStack {
                        Image(systemName: "graduationcap.fill")
                        Text(doctor.qualification)
                           
                    }.font(.subheadline)
                        .foregroundStyle(Color(.systemGray))
                    HStack {
                        Image(systemName: "briefcase.fill")
                        Text(doctor.experienceSince.ago)
                    }.font(.subheadline)
                        .foregroundStyle(Color(.systemGray))
                }
                Spacer()
                
                if !expanded {
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
            }.padding(.horizontal)
            
            if isExpanded {
                if isLoading {
                    ProgressView()
                        .padding()
                }
                else if availableSlots.isEmpty {
                    Text("No slots available for \(booking.forDate.startOfDay.localDate.dateString)")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    VStack(alignment: .leading) {
                        Text("Available Slots")
                            .textCase(.uppercase)
                            .font(.caption)
                            .padding(.horizontal)
                        SlotListView(slots: availableSlots, doctor: $booking.doctor, selection: $booking.selectedSlot)
                    }.padding(.top, 8)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .errorAlert(errorAlertMessage: errorAlertMessage)
        .onChange(of: booking.forDate) { _ in
            if isExpanded {
                fetchAvailableSlots()
            }
        }.onAppear {
            isExpanded = expanded
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
                let slots = try await doctor.getAvailableTimeSlots(for: booking.forDate)
                availableSlots = slots
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
}

#Preview {
    NavigationView {
        DoctorRow(doctor: Doctor.sample)
            .environmentObject(BookingViewModel())
    }
}

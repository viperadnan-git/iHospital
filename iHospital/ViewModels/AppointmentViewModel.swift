//
//  AppointmentViewModel.swift
//  iHospital
//
//  Created by Adnan Ahmad on 07/07/24.
//

import SwiftUI
import Combine
import Supabase

class AppointmentViewModel: ObservableObject {
    @Published var appointments: [Appointment] = []
    @Published var upcomingAppointments: [Appointment] = []
    @Published var pastAppointments: [Appointment] = []
    @Published var selectedSegment: Segment = .upcoming
    @Published var filterText: String = ""
    @Published var sortOption: SortOption = .date
    
    private var cancellables = Set<AnyCancellable>()
    
    enum Segment: String, CaseIterable {
        case upcoming = "Upcoming"
        case past = "Past"
    }
    
    enum SortOption: String, CaseIterable {
        case date = "Date"
        case doctor = "Doctor"
        case patient = "Patient"
        case status = "Status"
    }

    init() {
        Publishers.CombineLatest3($filterText, $sortOption, $appointments)
            .map { [weak self] filterText, sortOption, appointments in
                self?.applyFiltersAndSort(filterText: filterText, sortOption: sortOption) ?? []
            }
            .assign(to: &$appointments)
        
        $appointments
            .sink { [weak self] appointments in
                self?.splitAppointments(appointments: appointments)
            }
            .store(in: &cancellables)
    }
    
    func fetchAppointments() async {
        do {
            let fetchedAppointments = try await Appointment.fetchAllAppointments()
            DispatchQueue.main.async {
                self.appointments = fetchedAppointments
            }
        } catch {
            print("Error fetching appointments: \(error.localizedDescription)")
        }
    }
    
    private func applyFiltersAndSort(filterText: String, sortOption: SortOption) -> [Appointment] {
        var filteredAppointments = appointments
        
        if !filterText.isEmpty {
            filteredAppointments = appointments.filter { appointment in
                appointment.doctor.name.lowercased().contains(filterText.lowercased()) ||
                appointment.patient.name.lowercased().contains(filterText.lowercased()) ||
                appointment.appointmentStatus.rawValue.lowercased().contains(filterText.lowercased())
            }
        }
        
        switch sortOption {
        case .date:
            filteredAppointments.sort { $0.date < $1.date }
        case .doctor:
            filteredAppointments.sort { $0.doctor.userId.uuidString < $1.doctor.userId.uuidString }
        case .patient:
            filteredAppointments.sort { $0.patient.userId.uuidString < $1.patient.userId.uuidString }
        case .status:
            filteredAppointments.sort { $0.appointmentStatus.rawValue < $1.appointmentStatus.rawValue }
        }
        
        return filteredAppointments
    }
    
    private func splitAppointments(appointments: [Appointment]) {
        let now = Date()
        self.upcomingAppointments = appointments.filter { $0.date >= now }
        self.pastAppointments = appointments.filter { $0.date < now }
    }
}

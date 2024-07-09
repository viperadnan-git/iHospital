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
    @Published var allAppointments: [Appointment] = []
    @Published var appointments: [Appointment] = []
    @Published var upcomingAppointments: [Appointment] = []
    @Published var pastAppointments: [Appointment] = []
    
    @Published var isLoading: Bool = false
    
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
    
    @MainActor
    func fetchAppointments() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let fetchedAppointments = try await Appointment.fetchAllAppointments()
                self.allAppointments = fetchedAppointments
                self.appointments = fetchedAppointments
        } catch {
            print("Error fetching appointments: \(error.localizedDescription)")
        }
    }
    
    private func applyFiltersAndSort(filterText: String, sortOption: SortOption) -> [Appointment] {
        var filteredAppointments = allAppointments
        
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
            filteredAppointments.sort { $0.doctor.name < $1.doctor.name }
        case .patient:
            filteredAppointments.sort { $0.patient.name < $1.patient.name }
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

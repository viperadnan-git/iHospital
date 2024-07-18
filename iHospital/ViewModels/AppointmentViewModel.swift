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
    private var cached: [Appointment] = []
    
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
    
    @MainActor
    init() {
        fetchAppointments()
        Publishers.CombineLatest3($filterText, $sortOption, $allAppointments)
            .map { [weak self] filterText, sortOption, allAppointments in
                self?.applyFiltersAndSort(filterText: filterText, sortOption: sortOption, appointments: allAppointments) ?? []
            }
            .handleEvents(receiveOutput: { [weak self] filteredAppointments in
                self?.splitAppointments(appointments: filteredAppointments)
            })
            .assign(to: &$appointments)
    }
    
    @MainActor
    func fetchAppointments(showLoader: Bool = true, force: Bool = false) {
        if !force, !cached.isEmpty {
            allAppointments = cached
            self.splitAppointments(appointments: cached)
            return
        }
        Task {
            isLoading = showLoader
            defer { isLoading = false }
            
            do {
                let fetchedAppointments = try await Appointment.fetchAllAppointments()
                self.allAppointments = fetchedAppointments
                self.cached = fetchedAppointments
                self.splitAppointments(appointments: fetchedAppointments)
            } catch {
                print("Error while fetching appointments: \(error)")
            }
        }
    }
    
    private func applyFiltersAndSort(filterText: String, sortOption: SortOption, appointments: [Appointment]) -> [Appointment] {
        var filteredAppointments = appointments
        
        if !filterText.isEmpty {
            let lowercasedFilter = filterText.lowercased()
            filteredAppointments = filteredAppointments.filter { appointment in
                appointment.doctor.name.lowercased().contains(lowercasedFilter) ||
                appointment.patient.name.lowercased().contains(lowercasedFilter) ||
                appointment.date.dateTimeString.lowercased().contains(lowercasedFilter) ||
                appointment.appointmentStatus.rawValue.lowercased().contains(lowercasedFilter)
            }
        }
        
        filteredAppointments.sort { a, b in
            switch sortOption {
            case .date:
                return a.date > b.date
            case .doctor:
                return a.doctor.name < b.doctor.name
            case .patient:
                return a.patient.name < b.patient.name
            case .status:
                return a.appointmentStatus.rawValue < b.appointmentStatus.rawValue
            }
        }
        
        return filteredAppointments
    }
    
    private func splitAppointments(appointments: [Appointment]) {
        let now = Date()
        self.upcomingAppointments = appointments.filter { $0.date >= now && $0.appointmentStatus != .completed }
        self.pastAppointments = appointments.filter { $0.date < now || $0.appointmentStatus == .completed }
    }
    
    func rescheduleAppointment(appointment: Appointment, newDate: Date) async throws {
        let rescheduledAppointment = try await appointment.reschedule(date: newDate)
        if let index = allAppointments.firstIndex(where: { $0.id == appointment.id }) {
            DispatchQueue.main.async {
                self.allAppointments[index] = rescheduledAppointment
                self.splitAppointments(appointments: self.allAppointments)
            }
        }
    }
    
    func cancelAppointment(appointment: Appointment) async throws {
        try await appointment.cancel()
        if let index = allAppointments.firstIndex(where: { $0.id == appointment.id }) {
            DispatchQueue.main.async {
                self.allAppointments.remove(at: index)
                self.splitAppointments(appointments: self.allAppointments)
            }
        }
    }
}

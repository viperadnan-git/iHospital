//
//  PatientViewModel.swift
//  iHospital
//
//  Created by Adnan Ahmad on 05/07/24.
//

import Foundation
import Combine

class PatientViewModel: ObservableObject {
    @Published var patients: [Patient] = []
    @Published var currentPatient: Patient?
    
    private var cancellables = Set<AnyCancellable>()
    
    
    init() {
        fetchPatients()
    }
    
    func selectDefaultPatient() {
        if !patients.isEmpty {
            print("Selecting default patient")
            DispatchQueue.main.async {
                self.currentPatient = self.patients.first
            }
        }
    }
    
    func fetchPatients() {
        Task {
            do {
                let fetchedPatients = try await Patient.fetchAll()
                DispatchQueue.main.async {
                    self.patients = fetchedPatients
                    self.selectDefaultPatient()
                }
            } catch {
                print("Failed to fetch patients: \(error.localizedDescription)")
            }
        }
    }
    
    func addPatient(name: String, phoneNumber: Int, bloodGroup: BloodGroup, dateOfBirth: Date, height: Double?, weight: Double?, address: String) async throws {
        guard let user = SupaUser.shared else { return }
        
        let newPatient = try await Patient.addPatient(forUser: user.id, name: name, phoneNumber: phoneNumber, bloodGroup: bloodGroup, dateOfBirth: dateOfBirth, height: height, weight: weight, address: address)
        
        DispatchQueue.main.async {
            self.patients.append(newPatient)
        }
    }
}


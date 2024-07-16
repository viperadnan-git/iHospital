//
//  MedicalRecordViewModel.swift
//  iHospital
//
//  Created by Adnan Ahmad on 16/07/24.
//

import Foundation

class MedicalRecordViewModel: ObservableObject {
    @Published var medicalRecords:[MedicalRecord] = []
    @Published var isLoading: Bool = false
    
    private var cached: [MedicalRecord] = []
    
    @MainActor
    func fetchMedicalRecords(patient:Patient, showLoader: Bool = true, force: Bool = false) {
        if !force, !cached.isEmpty {
            medicalRecords = cached
            return
        }
        
        Task {
            isLoading = showLoader
            defer {
                isLoading = false
            }
            do {
                let medicalRecords = try await patient.fetchMedicalRecords()
                self.cached = medicalRecords
                self.medicalRecords = medicalRecords
            } catch {
                print("Error while fetching lab tests: \(error.localizedDescription)")
            }
        }
    }
}

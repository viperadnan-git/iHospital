//
//  MedicalRecordViewModel.swift
//  iHospital
//
//  Created by Adnan Ahmad on 16/07/24.
//

import Foundation

class MedicalRecordViewModel: ObservableObject {
    @Published var medicalRecords: [MedicalRecord] = []
    @Published var isLoading: Bool = false
    
    private var cached: [MedicalRecord] = []
    
    @MainActor
    /// Fetches medical records for the given patient
    /// - Parameters:
    ///   - patient: The patient for whom medical records are to be fetched
    ///   - showLoader: A flag to show loading indicator
    ///   - force: A flag to force fetch even if cached data exists
    func fetchMedicalRecords(patient: Patient, showLoader: Bool = true, force: Bool = false) {
        if !force, !cached.isEmpty {
            medicalRecords = cached
            return
        }
        
        Task {
            isLoading = showLoader
            defer { isLoading = false }
            do {
                let medicalRecords = try await patient.fetchMedicalRecords()
                self.cached = medicalRecords
                self.medicalRecords = medicalRecords
            } catch {
                print("Error while fetching medical records: \(error.localizedDescription)")
            }
        }
    }
}

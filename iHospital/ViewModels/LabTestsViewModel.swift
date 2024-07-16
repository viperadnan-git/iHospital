//
//  LabTestsViewModel.swift
//  iHospital
//
//  Created by Adnan Ahmad on 16/07/24.
//

import Foundation


class LabTestsViewModel: ObservableObject {
    @Published var labTests:[LabTest] = []
    @Published var isLoading: Bool = false
    
    private var cached: [LabTest] = []
    
    @MainActor
    func fetchLabTests(patient:Patient, showLoader: Bool = true, force: Bool = false) {
        if !force, !cached.isEmpty {
            labTests = cached
            return
        }
        
        Task {
            isLoading = showLoader
            defer {
                isLoading = false
            }
            do {
                let labTests = try await patient.fetchLabTests()
                self.cached = labTests
                self.labTests = labTests
            } catch {
                print("Error while fetching lab tests: \(error.localizedDescription)")
            }
        }
    }
}

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
    
    var cachedLabTests: [LabTest] = []
    
    @MainActor
    func fetchLabTests(patient:Patient, showLoader: Bool = true, force: Bool = false) {
        if !force, !cachedLabTests.isEmpty {
            labTests = cachedLabTests
            return
        }
        
        Task {
            isLoading = showLoader
            defer {
                isLoading = false
            }
            do {
                let labTests = try await patient.fetchLabTests()
                self.cachedLabTests = labTests
                self.labTests = labTests
            } catch {
                print("Error while fetching lab tests: \(error.localizedDescription)")
            }
        }
    }
}

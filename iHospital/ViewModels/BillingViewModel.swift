//
//  BillingViewModel.swift
//  iHospital
//
//  Created by Adnan Ahmad on 16/07/24.
//

import SwiftUI

class BillingViewModel: ObservableObject {
    @Published var invoices: [Invoice] = []
    
    @Published var isLoading: Bool = false
    
    @MainActor
    init() {
        fetchInvoices()
    }
    
    @MainActor
    func fetchInvoices(showLoader: Bool = true) {
        guard let user = SupaUser.shared else { return }
        
        Task {
            isLoading = showLoader
            defer { isLoading = false }
            
            do {
                invoices = try await user.fetchInvoices()
            } catch {
                print("Error while fetching invoices: \(error)")
            }
        }
    }
    
    func changeStatus(invoice: Invoice, status: PaymentStatus) async throws {
        let newInvoice = try await invoice.changePaymentStatus(status: status)
        if let index = invoices.firstIndex(where: { $0.id == newInvoice.id }) {
            DispatchQueue.main.async {
                self.invoices[index] = newInvoice
            }
        }
    }
}

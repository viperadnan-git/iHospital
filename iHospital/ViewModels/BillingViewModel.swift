//
//  BillingViewModel.swift
//  iHospital
//
//  Created by Adnan Ahmad on 16/07/24.
//

import SwiftUI

class BillingViewModel: ObservableObject {
    @Published var invoices: [Invoice] = []
    @Published var filteredInvoices: [Invoice] = []
    @Published var isLoading: Bool = false
    @Published var selectedFilter: FilterType = .all {
        didSet {
            applyFilter()
        }
    }
    
    enum FilterType: String, CaseIterable, Identifiable {
        case all = "All"
        case appointments = "Appointments"
        case labTests = "Lab Tests"
        case success = "Success"
        case pending = "Pending"
        case failed = "Failed"
        
        var id: String { self.rawValue }
    }

    @MainActor
    init() {
        fetchInvoices()
    }
    
    @MainActor
    /// Fetches invoices for the current user and applies the selected filter
    /// - Parameter showLoader: A flag to show loading indicator
    func fetchInvoices(showLoader: Bool = true) {
        guard let user = SupaUser.shared else { return }
        
        Task {
            isLoading = showLoader
            defer { isLoading = false }
            
            do {
                invoices = try await user.fetchInvoices()
                applyFilter()
            } catch {
                print("Error while fetching invoices: \(error.localizedDescription)")
            }
        }
    }
    
    /// Changes the payment status of an invoice
    /// - Parameters:
    ///   - invoice: The invoice to change status for
    ///   - status: The new payment status
    func changeStatus(invoice: Invoice, status: PaymentStatus) async throws {
        let newInvoice = try await invoice.changePaymentStatus(status: status)
        if let index = invoices.firstIndex(where: { $0.id == newInvoice.id }) {
            DispatchQueue.main.async {
                self.invoices[index] = newInvoice
                self.applyFilter()
            }
        }
    }
    
    /// Applies the selected filter to the list of invoices
    private func applyFilter() {
        switch selectedFilter {
        case .all:
            filteredInvoices = invoices
        case .appointments:
            filteredInvoices = invoices.filter { $0.paymentType == .appointment }
        case .labTests:
            filteredInvoices = invoices.filter { $0.paymentType == .labTest }
        case .success:
            filteredInvoices = invoices.filter { $0.status == .paid }
        case .pending:
            filteredInvoices = invoices.filter { $0.status == .pending }
        case .failed:
            filteredInvoices = invoices.filter { $0.status == .failed }
        }
    }
}

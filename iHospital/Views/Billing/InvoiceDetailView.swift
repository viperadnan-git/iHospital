//
//  InvoiceDetailView.swift
//  iHospital
//
//  Created by Adnan Ahmad on 17/07/24.
//

import SwiftUI

struct InvoiceDetailView: View {
    var invoice: Invoice
    
    @State private var showPaymentPage: Bool = false
    @EnvironmentObject private var viewModel: BillingViewModel
    
    var body: some View {
        VStack {
            Form {
                Section {
                    HStack {
                        Text(invoice.status.rawValue.uppercased())
                            .font(.title)
                            .bold()
                            .foregroundStyle(invoice.status.color)
                            .accessibilityLabel("Status: \(invoice.status.rawValue.uppercased())")
                        Spacer()
                        Text(invoice.amount.currency)
                            .font(.title)
                            .bold()
                            .accessibilityLabel("Amount: \(invoice.amount.currency)")
                    }
                    .padding()
                }
                
                Section(header: Text("Invoice Details")) {
                    HStack {
                        Text("Invoice ID")
                        Spacer()
                        Text("#\(invoice.id)")
                            .accessibilityLabel("Invoice ID: #\(invoice.id)")
                    }
                        
                    HStack {
                        Text("Patient")
                        Spacer()
                        Text(invoice.patient.name)
                            .accessibilityLabel("Patient: \(invoice.patient.name)")
                    }
                    
                    HStack {
                        Text("Payment Type")
                        Spacer()
                        Text(invoice.paymentType.name)
                            .accessibilityLabel("Payment Type: \(invoice.paymentType.name)")
                    }
                    
                    HStack {
                        Text("Created at")
                        Spacer()
                        Text(invoice.createdAt.dateTimeString)
                            .accessibilityLabel("Created at: \(invoice.createdAt.dateTimeString)")
                    }
                }
            }
            
            Spacer()
            
            if invoice.status == .pending {
                Button {
                    showPaymentPage.toggle()
                } label: {
                    Text("Pay Now")
                        .frame(maxWidth: .infinity)
                        .accessibilityLabel("Pay Now")
                        .accessibilityHint("Tap to proceed with payment")
                }
                .buttonStyle(.bordered)
                .tint(.accentColor)
                .padding()
            }
        }
        .sheet(isPresented: $showPaymentPage) {
            PaymentPageView(invoice: invoice)
                .environmentObject(viewModel)
        }
        .navigationTitle("Invoice #\(invoice.id)")
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Invoice details for Invoice #\(invoice.id)")
    }
}

#Preview {
    InvoiceDetailView(invoice: .sample)
        .environmentObject(BillingViewModel())
}

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
    @EnvironmentObject private var viewModel:BillingViewModel
    
    var body: some View {
        VStack {
            HStack {
                PaymentStatusIndicator(status: invoice.status)
                    .font(.title)
                    .textCase(.uppercase)
                Spacer()
                Text(invoice.amount.currency)
                    .font(.title)
                    .bold()
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding()
            
            Text("Invoice #\(invoice.id)")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Text("Patient: \(invoice.patient.firstName) \(invoice.patient.lastName)")
                .font(.title3)
                .fontWeight(.bold)
                .padding()
            
            Text("Payment Type: \(invoice.paymentType.name)")
                .font(.title3)
                .fontWeight(.bold)
                .padding()
            
            Text("Created At: \(invoice.createdAt.dateTimeString)")
                .font(.title3)
                .fontWeight(.bold)
                .padding()
            
            Spacer()
            
            if invoice.status == .pending {
                Button {
                    showPaymentPage.toggle()
                } label: {
                    Text("Pay Now")
                        .frame(maxWidth: .infinity)
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
    }
}


#Preview {
    InvoiceDetailView(invoice: .sample)
}

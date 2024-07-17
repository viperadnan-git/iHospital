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
            
            Form {
                Section {
                    HStack {
                        Text(invoice.status.rawValue.uppercased())
                            .font(.title)
                            .bold()
                            .foregroundStyle(invoice.status.color)
                        Spacer()
                        Text(invoice.amount.currency)
                            .font(.title)
                            .bold()
                    }
                    .padding()
                }
                
                Section(header: Text("Invoice Details")) {
                    HStack {
                        Text("Invoice ID")
                        Spacer()
                        Text("#\(invoice.id)")
                    }
                        
                    HStack {
                        Text("Patient")
                        Spacer()
                        Text(invoice.patient.name)
                    }
                    
                    HStack {
                        
                        Text("Payment Type")
                        Spacer()
                        Text(invoice.paymentType.name)
                    }
                    
                    HStack {
                        Text("Created at")
                        Spacer()
                        Text(invoice.createdAt.dateTimeString)
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

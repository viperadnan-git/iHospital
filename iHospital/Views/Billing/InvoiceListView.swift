

import SwiftUI

struct InvoiceListView: View {
    @StateObject private var viewModel = BillingViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                List {
                    ForEach(viewModel.filteredInvoices) { invoice in
                        NavigationLink(destination: InvoiceDetailView(invoice: invoice).environmentObject(viewModel)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(invoice.patient.firstName) - \(invoice.paymentType.rawValue.capitalized)")
                                        .fontWeight(.semibold)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    Text("\(invoice.createdAt.dateTimeString) #\(invoice.id)")
                                        .font(.subheadline)
                                        .foregroundStyle(.gray)
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    PaymentStatusIndicator(status: invoice.status)
                                        .font(.caption)
                                        .textCase(.uppercase)
                                    Text(invoice.amount.currency)
                                        .bold()
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    viewModel.fetchInvoices(showLoader: false)
                }
            }
        }
        .navigationTitle("Invoices")
        .navigationBarItems(trailing: filterMenu)
    }
    
    private var filterMenu: some View {
        Menu {
            ForEach(BillingViewModel.FilterType.allCases) { filter in
                Button(action: {
                    viewModel.selectedFilter = filter
                }) {
                    Text(filter.rawValue)
                }
            }
        } label: {
            Label("Filter", systemImage: "line.horizontal.3.decrease.circle")
        }
    }
}

struct PaymentStatusIndicator: View {
    var status: PaymentStatus
    var body: some View {
        HStack {
            Circle()
                .fill(status.color)
                .frame(width: 10, height: 10)
            Text(status.rawValue.capitalized)
        }
    }
}

#Preview {
    InvoiceListView()
}

import SwiftUI

struct InvoiceListView: View {
    @StateObject private var viewModel = BillingViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .accessibilityLabel("Loading invoices")
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
                                        .accessibilityLabel("Patient: \(invoice.patient.firstName), Payment type: \(invoice.paymentType.rawValue.capitalized)")
                                    Text("\(invoice.createdAt.dateTimeString) #\(invoice.id)")
                                        .font(.subheadline)
                                        .foregroundStyle(.gray)
                                        .accessibilityLabel("Date: \(invoice.createdAt.dateTimeString), Invoice ID: \(invoice.id)")
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    PaymentStatusIndicator(status: invoice.status)
                                        .font(.caption)
                                        .textCase(.uppercase)
                                    Text(invoice.amount.currency)
                                        .bold()
                                        .accessibilityLabel("Amount: \(invoice.amount.currency)")
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
        .accessibilityElement(children: .combine)
    }
    
    private var filterMenu: some View {
        Menu {
            ForEach(BillingViewModel.FilterType.allCases) { filter in
                Button(action: {
                    viewModel.selectedFilter = filter
                }) {
                    Text(filter.rawValue)
                        .accessibilityLabel("Filter by \(filter.rawValue)")
                }
            }
        } label: {
            Label("Filter", systemImage: "line.horizontal.3.decrease.circle")
                .accessibilityLabel("Filter menu")
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
                .accessibilityHidden(true) // Status color is conveyed through text
            Text(status.rawValue.capitalized)
                .accessibilityLabel("Status: \(status.rawValue.capitalized)")
        }
    }
}

#Preview {
    InvoiceListView()
}



import SwiftUI

struct PaymentPageView: View {
    let invoice: Invoice
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: BillingViewModel
    
    @StateObject private var errorAlertMessage = ErrorAlertMessage(title: "Failed to change payment status")
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            PaymentPageContent(changeStatus: changeStatus)
            Spacer()
        }
        .padding()
        .errorAlert(errorAlertMessage: errorAlertMessage)
    }
    
    private func changeStatus(_ status: PaymentStatus) {
        Task {
            do {
                try await viewModel.changeStatus(invoice: invoice, status: status)
                dismiss()
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
}

struct PaymentPageContent: View {
    var changeStatus: (PaymentStatus) -> Void
    
    var body: some View {
        Text("Payment Gateway Simulator")
            .font(.largeTitle)
            .bold()
            .padding()
        Button {
            changeStatus(.paid)
        } label: {
            Text("Success")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .tint(.green)
        Button {
            changeStatus(.failed)
        } label: {
            Text("Failed")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .tint(.red)
    }
}


struct PaymentPageSingleView: View {
    let paymentType: PaymentType
    let refrenceId: Int
    
    @Binding var isSuccess: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var errorAlertMessage = ErrorAlertMessage(title: "Failed to change payment status")
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            PaymentPageContent(changeStatus: changeStatus)
            Spacer()
        }
        .padding()
        .errorAlert(errorAlertMessage: errorAlertMessage)
    }
    
    private func changeStatus(_ status: PaymentStatus) {
        Task {
            do {
                _ = try await Invoice.changePaymentStatus(paymentType: paymentType, refrenceId: refrenceId, status: status)
                isSuccess = (status == .paid)
                dismiss()
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
}


#Preview {
    PaymentPageView(invoice: .sample)
        .environmentObject(BillingViewModel())
}

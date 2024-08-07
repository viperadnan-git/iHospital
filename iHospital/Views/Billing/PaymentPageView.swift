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
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Payment Page for Invoice")
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
            .accessibilityLabel("Payment Gateway Simulator")
        Button {
            changeStatus(.paid)
        } label: {
            Text("Success")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .tint(.green)
        .accessibilityLabel("Success")
        .accessibilityHint("Tap to mark payment as successful")
        Button {
            changeStatus(.failed)
        } label: {
            Text("Failed")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .tint(.red)
        .accessibilityLabel("Failed")
        .accessibilityHint("Tap to mark payment as failed")
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
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Payment Page for Payment Type: \(paymentType.rawValue)")
    }
    
    private func changeStatus(_ status: PaymentStatus) {
        Task {
            do {
                _ = try await Invoice.changePaymentStatus(paymentType: paymentType, referenceId: refrenceId, status: status)
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

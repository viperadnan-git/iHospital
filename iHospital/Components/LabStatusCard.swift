import SwiftUI

struct LabStatusCard: View {
    let pdfName: String
    let onTap: () -> Void

    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(width: 370, height: 150)
                .cornerRadius(15)
                .foregroundColor(Color(.secondarySystemBackground))
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Image(systemName: "testtube.2")
                        .foregroundColor(.accentColor)
                        .accessibilityHidden(true)
                    Text("Blood Test")
                        .font(.system(size: 20))
                        .bold()
                        .accessibilityLabel("Blood Test")
                }
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.accentColor)
                        .accessibilityHidden(true)
                    Text("John Doe")
                        .accessibilityLabel("Patient: John Doe")
                }
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.accentColor)
                        .accessibilityHidden(true)
                    Text("15th July, 2024")
                        .accessibilityLabel("Date: 15th July, 2024")
                }
                HStack {
                    Image(systemName: "clock.arrow.circlepath")
                        .foregroundColor(.accentColor)
                        .accessibilityHidden(true)
                    Text("Pending")
                        .accessibilityLabel("Status: Pending")
                }
            }
            .padding()
            .foregroundColor(Color(.label))
        }
        .onTapGesture {
            onTap()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Lab status card for Blood Test of John Doe on 15th July 2024, status pending")
    }
}

#Preview {
    LabStatusCard(pdfName: "sample") {}
}

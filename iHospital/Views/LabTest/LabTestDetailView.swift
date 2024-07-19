//
//  LabTestDetailView.swift
//  iHospital
//
//  Created by Adnan Ahmad on 16/07/24.
//

import SwiftUI

struct LabTestDetailView: View {
    let labTest: LabTest
    @State private var reportURL: URL?
    
    @StateObject private var errorAlertMessage = ErrorAlertMessage(title: "Failed to load report")
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(labTest.test.name)
                    .font(.title)
                    .bold()
                    .accessibilityLabel("Test: \(labTest.test.name)")
                HStack {
                    Text("By \(labTest.appointment.doctor.name)")
                        .accessibilityLabel("Doctor: \(labTest.appointment.doctor.name)")
                    Spacer()
                    Text(labTest.appointment.date.dateString)
                        .accessibilityLabel("Date: \(labTest.appointment.date.dateString)")
                }
                .font(.subheadline)
                .foregroundStyle(.gray)
            }
            .padding(.horizontal)
            Divider()

            if let reportURL = reportURL {
                PDFKitRepresentedView(reportURL)
                    .accessibilityLabel("PDF Report View")
            } else if labTest.reportPath != nil {
                Spacer()
                ProgressView()
                    .accessibilityLabel("Loading report")
            } else {
                Spacer()
                VStack(alignment: .leading) {
                    LabTestStatusIndicator(status: labTest.status)
                    switch labTest.status {
                    case .pending:
                        Text("Payment is pending for this test.")
                            .accessibilityLabel("Payment is pending for this test.")
                    case .waiting:
                        Text("Waiting for sample collection.")
                            .accessibilityLabel("Waiting for sample collection.")
                    case .inProgress:
                        Text("Sample is collected, creation of report is in progress.")
                            .accessibilityLabel("Sample is collected, creation of report is in progress.")
                    case .completed:
                        Text("Report is generated.")
                            .accessibilityLabel("Report is generated.")
                    }
                }
                .foregroundStyle(.gray)
            }
            
            Spacer()
            
        }
        .navigationTitle(labTest.patient.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: reportURL == nil ? nil : shareButton)
        .errorAlert(errorAlertMessage: errorAlertMessage)
        .onAppear {
            if labTest.reportPath != nil {
                fetchReport()
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Lab test details for \(labTest.patient.name)")
    }
    
    private var shareButton: some View {
        Button(action: {
            shareReport()
        }) {
            Image(systemName: "square.and.arrow.up")
        }
        .accessibilityLabel("Share Report")
        .accessibilityHint("Tap to share the report")
    }
    
    private func fetchReport() {
        Task {
            do {
                let reportURL = try await labTest.downloadReport()
                self.reportURL = reportURL
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
    
    private func shareReport() {
        guard let reportURL = reportURL else { return }
        
        let activityController = UIActivityViewController(activityItems: [reportURL], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityController, animated: true, completion: nil)
        }
    }
}

struct LabTestStatusIndicator: View {
    let status: LabTestStatus

    var body: some View {
        HStack {
            Circle()
                .fill(status.color)
                .frame(width: 10, height: 10)
                .accessibilityHidden(true)
            Text(status.rawValue.capitalized)
                .font(.footnote)
                .accessibilityLabel("Status: \(status.rawValue.capitalized)")
        }
    }
}

#Preview {
    LabTestDetailView(labTest: LabTest.sample)
}

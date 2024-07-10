//
//  LabResultView.swift
//  iHospital
//
//  Created by Shoaib Akhtar on 10/07/24.
//

import SwiftUI
import PDFKit

struct PDFView: UIViewRepresentable {
    let pdfName: String
    
    func makeUIView(context: Context) -> PDFKit.PDFView {
        let pdfView = PDFKit.PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .horizontal
        pdfView.usePageViewController(true, withViewOptions: nil)
        
        if let url = Bundle.main.url(forResource: pdfName, withExtension: "pdf") {
            pdfView.document = PDFDocument(url: url)
        } else {
            print("Failed to load \(pdfName).pdf")
        }
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFKit.PDFView, context: Context) {
        if let url = Bundle.main.url(forResource: pdfName, withExtension: "pdf") {
            pdfView.document = PDFDocument(url: url)
        }
    }
}

struct LabResultView: View {
    let pdfName: String
    
    var body: some View {
            PDFView(pdfName: pdfName)
                .edgesIgnoringSafeArea(.all)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            sharePDF()
                        }) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                }
    }
    
    func sharePDF() {
        if let url = Bundle.main.url(forResource: pdfName, withExtension: "pdf") {
            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                rootViewController.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
}

#Preview {
    NavigationView {
        LabResultView(pdfName: "sample")
    }
}

//
//  PDFKitRepresentedView.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 15/07/24.
//

import SwiftUI
import PDFKit

struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL

    init(_ url: URL) {
        self.url = url
    }

    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {}
}


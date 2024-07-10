//
//  LabTestView.swift
//  iHospital
//
//  Created by Shoaib Akhtar on 10/07/24.
//

//
//  LabTestView.swift
//  iHospital
//
//  Created by Shoaib Akhtar on 10/07/24.
//

import SwiftUI

struct LabTestView: View {
    @State private var selectedPDFName: String?
    @State private var isShowingLabResult = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    // Displaying LabStatusCard four times
                    ForEach(0..<4) { index in
                        LabStatusCard(pdfName: "sample") {
                            selectedPDFName = "sample"
                            isShowingLabResult = true
                        }
                        .padding(.bottom, 10)
                    }
                }
                .padding()
            }
            .navigationTitle("Lab Records")
            .navigationDestination(isPresented: $isShowingLabResult) {
                if let pdfName = selectedPDFName {
                    LabResultView(pdfName: pdfName)
                }
            }
        }
    }
}

#Preview {
    LabTestView()
}

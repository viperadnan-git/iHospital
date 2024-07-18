//
//  BookedBedsCard.swift
//  iHospital
//
//  Created by Roshan on 11/07/24.
//

import SwiftUI

struct BookedBedsCard: View {
    @State private var showModal = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("General ward")
                        .font(.headline)
                        .accessibilityLabel("Ward: General ward")
                    
                    Text("Booking Date: 27 JUL")
                        .font(.subheadline)
                        .accessibilityLabel("Booking Date: 27th July")
                }
                Spacer()
            }
            
            Text("Patient Name: Prateek Kumar")
                .padding(.top, 16)
                .accessibilityLabel("Patient Name: Prateek Kumar")
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
        .frame(maxWidth: .infinity)
        .sheet(isPresented: $showModal) {
            BedBillingPage()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Booked bed card")
    }
}

#Preview {
    BookedBedsCard()
        .padding()
        .background(Color(.systemBackground))
        .previewLayout(.sizeThatFits)
}

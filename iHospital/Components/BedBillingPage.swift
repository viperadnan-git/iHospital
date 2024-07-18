//
//  BedBillingPage.swift
//  iHospital
//
//  Created by Roshan on 11/07/24.
//

import SwiftUI

struct BedBillingPage: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image("profile_image")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 90)
                    .accessibilityHidden(true) // Profile image does not add significant info for screen readers
                Spacer()
                VStack(alignment: .leading) {
                    Text("MR. Adtiya Kumar")
                        .font(.headline)
                        .accessibilityLabel("Patient: MR. Adtiya Kumar")
                    Text("General ward")
                        .font(.subheadline)
                        .accessibilityLabel("Ward: General ward")
                    Text("VIP Room")
                        .font(.subheadline)
                        .accessibilityLabel("Room: VIP Room")
                }
                Spacer()
            }
            .padding()

            Text("Advised by: Dr. Steven Strange")
                .padding(.bottom, 8)
                .accessibilityLabel("Advised by: Dr. Steven Strange")

            HStack {
                Text("Admission Date:")
                Spacer()
                Text("21 JUL")
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Admission Date: 21st July")

            HStack {
                Text("Discharge Date:")
                Spacer()
                Text("21 JUL")
            }
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Discharge Date: 21st July")

            HStack {
                Text("Total bill generated:")
                Spacer()
                Text(5700.formatted(.currency(code: "INR")))
                    .foregroundColor(.green)
            }
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Total bill generated: 5700 Indian Rupees")

            Button(action: {
                print("Button tapped!")
            }) {
                Text("Pay Now")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(10)
            }
            .padding([.top, .bottom], 16)
            .accessibilityLabel("Pay Now")
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding([.leading, .top, .trailing, .bottom])
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Bed billing information")
    }
}

struct BedBillingPage_Previews: PreviewProvider {
    static var previews: some View {
        BedBillingPage()
    }
}

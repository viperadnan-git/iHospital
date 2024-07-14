//
//  bedBillingPage.swift
//  iHospital
//
//  Created by Roshan on 11/07/24.
//

import SwiftUI

// 
struct BedBillingPage: View {
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Image("profile_image")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 90)
                    Spacer()
                VStack(alignment: .leading) {
                    Text("MR. Adtiya Kumar")
                    
                    Text("General ward")
                    Text("VIP Room")
                }
                Spacer()
        
            }
            .padding()
            Text("Advised by:  Dr. Steven Strange")
                .padding(.bottom,8)
            HStack{
                Text("Admission Date:")
                Spacer()
                Text("21 JUL")
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            HStack{
                Text("Discharge Date:")
                Spacer()
                Text("21 JUL")
            }
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
            HStack{
                Text("Total bill generated:")
                Spacer()
                Text(5700.formatted(.currency(code: "INR")))
                    .foregroundColor(.green)
            }
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
            
            Button(action: {
                            // Action to perform when the button is tapped
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
                        .padding([.top, .bottom],16)
        }
        
        .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding([.leading, .top, .trailing, .bottom])
                
        
    }
}

struct bedBillingPage_Previews: PreviewProvider {
    static var previews: some View {
        BedBillingPage()
    }
}

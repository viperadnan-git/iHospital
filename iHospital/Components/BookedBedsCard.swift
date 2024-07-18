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
       
            VStack(alignment: .leading){
                HStack(alignment: .top){
                    VStack(alignment: .leading){
                        Text("General ward")
                        
                        Text("Booking Date: 27 JUL")
                        
                    }
                    Spacer()
                    
                    .sheet(isPresented: $showModal) {
                        BedBillingPage()
                    }
                    
                }
                
                Text("Patient Name: Prateek Kumar")
                    .padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0))
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            .frame(maxWidth: .infinity)
            
            
            
        
    }
}

#Preview {
    BookedBedsCard()
}

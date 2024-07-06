//
//  AppointmentBrowseView.swift
//  iHospital
//
//  Created by Adnan Ahmad on 05/07/24.
//

import SwiftUI

struct AppointmentBrowseView: View {
    @State private var selectedDate:Date = Date()
    
    var body: some View {
        VStack {
            FSCalenderView(selectedDate: $selectedDate)
                .border(Color.accentColor, width: 1).frame(height: 100)
            
            TextField("Search", text: .constant(""))
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding()
            Spacer()
        }
    }
}

#Preview {
    AppointmentBrowseView()
}

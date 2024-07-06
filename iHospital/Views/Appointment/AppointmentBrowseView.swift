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
            HorizontalCalenderView(selectedDate: $selectedDate)
            Divider()
            
            TextField("Search", text: .constant(""))
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding()
            Spacer()
        }.navigationTitle("Browse Appointments")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AppointmentBrowseView()
}

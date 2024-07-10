//
//  LabStatusCard.swift
//  iHospital
//
//  Created by Shoaib Akhtar on 10/07/24.
//

import SwiftUI

struct LabStatusCard: View {
    let pdfName: String
    let onTap: () -> Void
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 370, height: 150)
                .cornerRadius(15)
                .foregroundColor(Color.gray)
            Text("Lab Result Card")
        }
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    LabStatusCard(pdfName: "sample") {}
}


//VStack(alignment: .leading) {
//    HStack {
//        Image("DoctorImage")
//            .resizable()
//            .scaledToFit()
//            .frame(height: 48)
//            .padding(.trailing, 4)
//
//        VStack(alignment: .leading) {
//            Text("Doctor Name")
//                .font(.title3)
//            Text("2 years of experience")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//        }
//    }
//
//    HStack {
//        Image(systemName: "person")
//            .foregroundColor(.accentColor)
//        Text("Patient Name")
//    }
//    HStack {
//        Image(systemName: "calendar")
//            .foregroundColor(.accentColor)
//        Text("10 July 2024 at 12:34 PM")
//    }
//    HStack {
//        Image(systemName: "flask")
//            .foregroundColor(.accentColor)
//        Text("Result Status")
//    }
//}
//.padding()
//.background(Color(.secondarySystemBackground))
//.cornerRadius(8)
//.frame(maxWidth: .infinity)
//.padding(.horizontal)

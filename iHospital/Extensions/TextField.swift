//
//  TextField.swift
//  iHospital
//
//  Created by Adnan Ahmad on 06/07/24.
//

import SwiftUI

extension TextField {
    func withIcon(_ icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.secondary)
            self
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 0)
                .foregroundColor(.black)
        )
    }
}

#Preview {
    VStack {
        TextField("Password", text: .constant(""))
            .withIcon("lock")
        
        TextField("Username", text: .constant(""))
            .withIcon("person")
    }
    .padding()
}

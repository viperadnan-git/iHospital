//
//  TextField.swift
//  iHospital
//
//  Created by Adnan Ahmad on 06/07/24.
//

import SwiftUI

extension TextField {
    /// Adds an icon to the left of the TextField
    /// - Parameter icon: The name of the system image to display
    /// - Returns: A view containing the TextField with the specified icon
    func withIcon(_ icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.secondary)
                .accessibilityHidden(true) // Hides the decorative image from accessibility
            self
                .accessibilityLabel(Text("Text Field")) // Custom accessibility label for better context
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
            .accessibilityLabel("Password") // Accessibility label for the TextField
        
        TextField("Username", text: .constant(""))
            .withIcon("person")
            .accessibilityLabel("Username") // Accessibility label for the TextField
    }
    .padding()
}

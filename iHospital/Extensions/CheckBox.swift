//
//  CheckBox.swift
//  iHospital
//
//  Created by Adnan Ahmad on 03/07/24.
//

import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .foregroundColor(configuration.isOn ? .accentColor : .gray)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
                .accessibilityLabel(configuration.isOn ? "Checked" : "Unchecked")
                .accessibilityAddTraits(.isButton)
            configuration.label
        }
    }
}

#Preview {
    VStack {
        Toggle("Option 1", isOn: .constant(true))
            .toggleStyle(CheckboxToggleStyle())
        
        Toggle("Option 2", isOn: .constant(false))
            .toggleStyle(CheckboxToggleStyle())
    }
    .padding()
}

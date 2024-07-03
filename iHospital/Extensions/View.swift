//
//  View.swift
//  iHospital
//
//  Created by Adnan Ahmad on 03/07/24.
//

import SwiftUI

struct ErrorAlert: ViewModifier {
    @Binding var title: String?
    @Binding var message: String?
    
    var isShowingError: Binding<Bool> {
        Binding(
            get: { message != nil },
            set: { newValue in
                if !newValue {
                    message = nil
                }
            }
        )
    }
    
    func body(content: Content) -> some View {
        content
            .alert(isPresented: isShowingError) {
                Alert(
                    title: Text(title ?? "Oops!"),
                    message: Text(message ?? "An unknown error occurred."),
                    dismissButton: .default(Text("OK"))
                )
            }
    }
}

struct PaddedTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
    }
}

extension View {
    func errorAlert(title: Binding<String?> = .constant("Error"), message: Binding<String?>) -> some View {
        self.modifier(ErrorAlert(title: title, message: message))
    }
    
    func paddedTextFieldStyle() -> some View {
        self.modifier(PaddedTextFieldStyle())
    }
}

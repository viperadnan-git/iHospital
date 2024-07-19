//
//  ViewModifiers.swift
//  iHospital
//
//  Created by Adnan Ahmad on 03/07/24.
//

import SwiftUI

class ErrorAlertMessage: ObservableObject {
    @Published var title: String
    @Published var message: String? = nil
    
    init(title: String = "Error") {
        self.title = title
    }
}

struct ErrorAlert: ViewModifier {
    @ObservedObject var errorAlertMessage: ErrorAlertMessage
    
    private var isShowingError: Binding<Bool> {
        Binding(
            get: { errorAlertMessage.message != nil },
            set: { newValue in
                if !newValue {
                    errorAlertMessage.message = nil
                }
            }
        )
    }
    
    func body(content: Content) -> some View {
        content
            .alert(isPresented: isShowingError) {
                Alert(
                    title: Text(errorAlertMessage.title),
                    message: Text(errorAlertMessage.message ?? "Something went wrong"),
                    dismissButton: .default(Text("OK"))
                )
            }
    }
}

struct PaddedTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(8)
    }
}

extension View {
    /// Adds an error alert to the view
    /// - Parameter errorAlertMessage: An instance of ErrorAlertMessage to manage the alert state
    /// - Returns: A view with an error alert
    func errorAlert(errorAlertMessage: ErrorAlertMessage) -> some View {
        self.modifier(ErrorAlert(errorAlertMessage: errorAlertMessage))
    }
    
    /// Applies padding and background style to a TextField
    /// - Returns: A styled TextField view
    func paddedTextFieldStyle() -> some View {
        self.modifier(PaddedTextFieldStyle())
    }
}

#Preview {
    VStack {
        TextField("Example", text: .constant(""))
            .paddedTextFieldStyle()
            .padding()
    }
    .errorAlert(errorAlertMessage: ErrorAlertMessage())
}

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
    
    init(title: String) {
        self.title = title
    }
    
    init(){
        self.title = "Error"
    }
}


struct ErrorAlert: ViewModifier {
    @ObservedObject var errorAlertMessage: ErrorAlertMessage
    
    var isShowingError: Binding<Bool> {
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
    func errorAlert(errorAlertMessage: ErrorAlertMessage) -> some View {
        self.modifier(ErrorAlert(errorAlertMessage: errorAlertMessage))
    }
    
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

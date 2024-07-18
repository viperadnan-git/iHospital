//
//  LoaderButton.swift
//  iHospital
//
//  Created by Adnan Ahmad on 03/07/24.
//

import SwiftUI

struct LoaderButton<Content: View>: View {
    @Binding var isLoading: Bool
    var action: () -> Void
    var content: Content

    init(isLoading: Binding<Bool>, action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self._isLoading = isLoading
        self.action = action
        self.content = content()
    }

    var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .padding()
                } else {
                    content
                        .opacity(isLoading ? 0 : 1)
                        .padding()
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(8)
            .disabled(isLoading)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel(isLoading ? "Loading" : "Button")
        .accessibilityHint(isLoading ? "Button is currently loading" : "Tap to perform action")
    }
}

#Preview {
    @State var isLoading = false
    return LoaderButton(isLoading: $isLoading, action: {
        print("Button tapped")
        isLoading = true
    }) {
        Text("Button")
    }
}

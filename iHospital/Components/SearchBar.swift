//
//  SearchBar.swift
//  iHospital
//
//  Created by Shoaib Akhtar on 04/07/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @State private var isEditing = false

    var body: some View {
        HStack {
            TextField("Search Doctor and Departments", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if isEditing {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                                    .accessibilityLabel("Clear search text")
                            }
                        }
                    }
                )
                .foregroundColor(.primary)
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
                .accessibilityHint("Search for doctors and departments")

            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                        .foregroundColor(.blue)
                        .accessibilityLabel("Cancel search")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Search bar")
    }
}

struct SearchBar_Previews: PreviewProvider {
    @State static var text = ""
    static var previews: some View {
        SearchBar(text: $text)
            .padding()
            .background(Color(.systemBackground))
            .previewLayout(.sizeThatFits)
    }
}

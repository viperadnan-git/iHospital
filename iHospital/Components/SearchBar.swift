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
                .background(Color(.systemGray6)) // Background color similar to native iOS search bar
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray) // Icon color similar to native iOS search bar
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if isEditing {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .foregroundColor(.primary) // Text color similar to native iOS search bar
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }

            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                        .foregroundColor(.blue) // Cancel button color similar to native iOS search bar
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                //.animation(.default)
            }
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    @State static var text = ""
    static var previews: some View {
        SearchBar(text: $text)
            .padding()
            .background(Color(.systemBackground)) // Background color to simulate a typical iOS view
            .previewLayout(.sizeThatFits)
    }
}

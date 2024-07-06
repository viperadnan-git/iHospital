//
//  AppointmentSearch.swift
//  iHospital
//
//  Created by Adnan Ahmad on 06/07/24.
//

import SwiftUI

struct AppointmentSearch: View {
    @State private var searchText = ""
    @State private var searchResults: [Search] = []
    @State private var isLoading = false
    
    @FocusState private var isTextFieldFocused: Bool
    @State private var debounceTimer: Timer?
    
    @Binding var selectedSearchResult: Search?
    @Binding var showSearch: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search doctors or departments", text: $searchText, onCommit: search)
                        .withIcon("magnifyingglass")
                        .paddedTextFieldStyle()
                        .padding(.horizontal)
                        .focused($isTextFieldFocused)
                        .onChange(of: searchText) {
                            debounceSearch()
                        }
                }
                
                if isLoading {
                    VStack {
                        Spacer()
                        ProgressView()
                            .padding(.trailing)
                        Spacer()
                    }
                } else {
                    List(searchResults) { result in
                        Button(action: {
                            selectedSearchResult = result
                            showSearch = false
                        }) {
                            HStack {
                                Image(systemName: result.icon)
                                    .foregroundColor(result.type == .doctor ? .blue : .green)
                                Text(result.name)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                isTextFieldFocused = true
            }
            .toolbar {
                Button("Cancel", action: {
                    showSearch = false
                })
            }
        }
    }
    
    private func debounceSearch() {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            search()
        }
    }
    
    private func search() {
        guard !searchText.isEmpty else {
            isLoading = false
            return
        }
        
        isLoading = true
        Task {
            do {
                let results = try await Search.doctorsOrDepartments(byName: searchText)
                searchResults = results
            } catch {
                print("Error: \(error)")
            }
            isLoading = false
        }
    }
}


#Preview {
    AppointmentSearch(selectedSearchResult: .constant(nil), showSearch: .constant(true))
}
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
    @State private var searched: Bool = false
    
    @Binding var selectedSearchResult: Search?
    @Binding var selectedDepartment: Department?
    @Binding var showSearch: Bool
    
    @StateObject private var errorAlertMessage = ErrorAlertMessage(title: "Unable to search")
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search doctors or departments", text: $searchText, onCommit: search)
                        .withIcon("magnifyingglass")
                        .paddedTextFieldStyle()
                        .padding(.horizontal)
                        .focused($isTextFieldFocused)
                        .onChange(of: searchText) { _ in
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
                    if searched && searchResults.isEmpty {
                        VStack {
                            Spacer()
                            Text("No results found")
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    } else {
                        List(searchResults) { result in
                            Button(action: {
                                if case .department(let department) = result.item {
                                    selectedDepartment = department
                                } else {
                                    selectedSearchResult = result
                                }
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
            }.errorAlert(errorAlertMessage: errorAlertMessage)
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
                searched = true
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
            isLoading = false
        }
    }
}

#Preview {
    AppointmentSearch(selectedSearchResult: .constant(nil), selectedDepartment: .constant(nil), showSearch: .constant(true))
}

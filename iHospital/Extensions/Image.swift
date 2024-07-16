//
//  Image.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 14/07/24.
//

import SwiftUI

extension Image {
    static func asyncImage(loadData: @escaping () async throws -> Data, placeholder: Image = Image(systemName: "photo.fill")) -> some View {
        AsyncImage(loadData: loadData, placeholder: placeholder)
    }
    
    static func validationIcon(for error: String?) -> some View {
        Group {
            if let error = error {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(.red)
                    .popover(isPresented: .constant(true)) {
                        Text(error).padding()
                    }
            }
        }
    }
}

struct AsyncImage: View {
    let loadData: () async throws -> Data
    let placeholder: Image
    
    @State private var image: Image? = nil
    @State private var errorOccurred = false

    var body: some View {
        Group {
            if let image = image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else if errorOccurred {
                placeholder
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(Color(.systemGray))
            } else {
                ProgressView()
                    .onAppear {
                        Task {
                            await loadImage()
                        }
                    }.frame(maxWidth: .infinity)
            }
        }
    }

    private func loadImage() async {
        do {
            let data = try await loadData()
            if let uiImage = UIImage(data: data) {
                image = Image(uiImage: uiImage)
            } else {
                errorOccurred = true
            }
        } catch {
            errorOccurred = true
        }
    }
}

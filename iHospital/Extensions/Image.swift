//
//  Image.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 14/07/24.
//

//import SwiftUI
//
//extension Image {
//    static func asyncImage(loadData: @escaping () async throws -> Data, placeholder: Image = Image(systemName: "photo.fill")) -> some View {
//        AsyncImage(loadData: loadData, placeholder: placeholder)
//    }
//    
//    static func validationIcon(for error: String?) -> some View {
//        Group {
//            if let error = error {
//                Image(systemName: "exclamationmark.circle.fill")
//                    .foregroundColor(.red)
//                    .popover(isPresented: .constant(true)) {
//                        Text(error).padding()
//                    }
//            }
//        }
//    }
//}
//
//struct AsyncImage: View {
//    let loadData: () async throws -> Data
//    let placeholder: Image
//    
//    @State private var image: Image? = nil
//    @State private var errorOccurred = false
//
//    var body: some View {
//        Group {
//            if let image = image {
//                image
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//            } else if errorOccurred {
//                placeholder
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .foregroundStyle(Color(.systemGray))
//            } else {
//                ProgressView()
//                    .onAppear {
//                        Task {
//                            await loadImage()
//                        }
//                    }.frame(maxWidth: .infinity)
//            }
//        }
//    }
//
//    private func loadImage() async {
//        do {
//            let data = try await loadData()
//            if let uiImage = UIImage(data: data) {
//                image = Image(uiImage: uiImage)
//            } else {
//                errorOccurred = true
//            }
//        } catch {
//            errorOccurred = true
//        }
//    }
//}

import SwiftUI

class ImageCache {
    static let shared = ImageCache()
    private init() {}
    
    private let cache = NSCache<NSString, UIImage>()
    
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: NSString(string: key))
    }
}

extension Image {
    static func asyncImage(loadData: @escaping () async throws -> Data, placeholder: Image = Image(systemName: "photo.fill"), cacheKey: String, showProgress: Bool = true) -> some View {
        AsyncImage(loadData: loadData, placeholder: placeholder, cacheKey: cacheKey, showProgress: showProgress)
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
    let cacheKey: String
    let showProgress: Bool
    
    @State private var image: Image? = nil
    @State private var errorOccurred = false
    
    var body: some View {
        Group {
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
            } else if errorOccurred || showProgress == false {
                placeholder
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(Color(.systemGray))
                    .task {
                        await loadImage()
                    }
            } else {
                ProgressView()
                    .task {
                        await loadImage()
                    }
            }
        }
    }
    
    private func loadImage() async {
        if let cachedUIImage = ImageCache.shared.getImage(forKey: cacheKey) {
            image = Image(uiImage: cachedUIImage)
            return
        }
        
        do {
            let data = try await loadData()
            if let uiImage = UIImage(data: data) {
                ImageCache.shared.setImage(uiImage, forKey: cacheKey)
                image = Image(uiImage: uiImage)
            } else {
                errorOccurred = true
            }
        } catch {
            errorOccurred = true
        }
    }
}


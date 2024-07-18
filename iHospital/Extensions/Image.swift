//
//  Image.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 14/07/24.
//

import SwiftUI

/// A singleton cache for storing and retrieving images
class ImageCache {
    static let shared = ImageCache()
    private init() {}
    
    private let cache = NSCache<NSString, UIImage>()
    
    /// Retrieves an image from the cache
    /// - Parameter key: The key used to identify the cached image
    /// - Returns: The cached image if it exists, otherwise nil
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }
    
    /// Caches an image with a specified key
    /// - Parameters:
    ///   - image: The image to be cached
    ///   - key: The key used to identify the cached image
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: NSString(string: key))
    }
}

extension Image {
    /// Creates an asynchronous image view with caching and a placeholder
    /// - Parameters:
    ///   - loadData: A closure that returns image data asynchronously
    ///   - placeholder: An optional placeholder image to display while loading
    ///   - cacheKey: The key used to cache the image
    ///   - showProgress: A boolean indicating whether to show a progress view
    /// - Returns: A view displaying the image or placeholder
    static func asyncImage(loadData: @escaping () async throws -> Data, placeholder: Image = Image(systemName: "photo.fill"), cacheKey: String, showProgress: Bool = true) -> some View {
        AsyncImage(loadData: loadData, placeholder: placeholder, cacheKey: cacheKey, showProgress: showProgress)
    }
    
    /// Displays a validation icon with an optional error message
    /// - Parameter error: An optional error message to display
    /// - Returns: A view with an icon and a popover for the error message
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
            } else if errorOccurred || !showProgress {
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
    
    /// Loads the image either from cache or by fetching data
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

#Preview {
    let sampleData: () async throws -> Data = {
        let sampleText = "Sample image data"
        return Data(sampleText.utf8)
    }
    
    return Image.asyncImage(loadData: sampleData, cacheKey: "sampleKey")
}

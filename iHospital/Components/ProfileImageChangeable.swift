//
//  ProfileImageChangeable.swift
//  iHospital
//
//  Created by Aditya on 18/07/24.
//

import SwiftUI
import PhotosUI

struct ProfileImageChangeable: View {
    let userId: String
    var placeholder: Image = Image(systemName: "person.crop.circle.fill")
    
    @State var image: Image?
    @State var imageData: Data?
    @State var isChangingImage: Bool = false
    
    @State private var isShowingPhotoPicker = false
    @State private var isShowingCamera = false
    @State private var showActionSheet = false
    
    var body: some View {
        VStack {
            Group {
                if isChangingImage {
                    ProgressView()
                } else if let imageData = imageData {
                    if let image = image {
                        image.resizable()
                    } else {
                        ProgressView()
                            .onAppear {
                                funcLoadImage(data: imageData)
                            }
                    }
                } else {
                    Image.asyncImage(
                        loadData: {
                            try await fetchImageData(for: userId)
                        },
                        placeholder: placeholder,
                        cacheKey: "AV#\(userId)",
                        showProgress: false
                    )
                }
            }.scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
            
            
            
            Button {
                showActionSheet = true
            } label: {
                HStack {
                    Image(systemName: "photo.fill")
                    Text("Change Image")
                }
            }
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(
                    title: Text("Select Image Source"),
                    buttons: [
                        .default(Text("Photo Library")) {
                            isShowingPhotoPicker = true
                        },
                        .default(Text("Camera")) {
                            isShowingCamera = true
                        },
                        .cancel()
                    ]
                )
            }
        }
        .sheet(isPresented: $isShowingPhotoPicker) {
            ImagePicker(sourceType: .photoLibrary, selectedImageData: $imageData)
        }
        .sheet(isPresented: $isShowingCamera) {
            ImagePicker(sourceType: .camera, selectedImageData: $imageData)
        }
        .onChange(of: imageData) { newImageData in
            Task {
                guard let data = newImageData else {
                    return
                }
                
                do {
                    isChangingImage = true
                    defer { isChangingImage = false }
                    
                    try await uploadImage(image: data)
                    ImageCache.shared.setImage(UIImage(data: data)!, forKey: "AV#\(userId)")
                    print("Image uploaded successfully")
                } catch {
                    print("Error while saving data \(error)")
                }
            }
        }
    }
    
    private func fetchImageData(for userId: String) async throws -> Data {
        let path = "\(userId.lowercased())/avatar.jpeg"
        return try await supabase.storage.from(SupabaseBucket.avatars.id)
            .download(path: path)
    }
    
    private func funcLoadImage(data: Data) {
        if let uiImage = UIImage(data: data) {
            image = Image(uiImage: uiImage)
        } else {
            image = Image(systemName: "person.crop.circle.fill")
        }
    }
    
    private func uploadImage(image: Data) async throws {
        let path = "\(userId.lowercased())/avatar.jpeg"
        try await supabase.storage.from(SupabaseBucket.avatars.id).upload(path: path, file: image, options: .init(upsert: true))
    }
}


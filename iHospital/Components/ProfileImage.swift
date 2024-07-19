//
//  ProfileImage.swift
//  iHospital
//
//  Created by Aditya on 18/07/24.
//

import SwiftUI

struct ProfileImage: View {
    let userId: String
    var placeholder: Image = Image(systemName: "person.crop.circle.fill")
    
    var body: some View {
        Image.asyncImage(
            loadData: {
                try await fetchImageData(for: userId)
            },
            placeholder: placeholder,
            cacheKey: "AV#\(userId)",
            showProgress: false
        )
        .clipShape(Circle())
        .accessibilityLabel("Profile image")
        .accessibilityHint("Profile image for user with ID \(userId)")
    }
    
    private func fetchImageData(for userId: String) async throws -> Data {
        let path = "\(userId.lowercased())/avatar.jpeg"
        return try await supabase.storage.from(SupabaseBucket.avatars.id)
            .download(path: path)
    }
}

struct ProfileImage_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImage(userId: "sampleUserID")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

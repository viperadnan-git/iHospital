//
//  ImageButton.swift
//  iHospital
//
//  Created by Shoaib Akhtar on 04/07/24.
//

import SwiftUI

struct ImageButton: View {
    var imageName: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity)
                .cornerRadius(10)
                .clipped()
        }
        .frame(maxWidth: .infinity)
        .cornerRadius(10)
        .padding(.horizontal, 14)
    }
}

struct ImageButton_Previews: PreviewProvider {
    static var previews: some View {
        ImageButton(imageName: "Image") {
            // Handle action
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

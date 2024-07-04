//
//  FeatureButton.swift
//  iHospital
//
//  Created by Shoaib Akhtar on 04/07/24.
//

import SwiftUI

struct FeatureButton: View {
    var imageName: String
    var title: String

    var body: some View {
        VStack {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .padding()
                .background(Color.accentColor.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(width: 100, height: 120)
    }
}

struct FeatureButton_Previews: PreviewProvider {
    static var previews: some View {
        FeatureButton(imageName: "star.fill", title: "Feature Button")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

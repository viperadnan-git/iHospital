//
//  FeatureButton.swift
//  iHospital
//
//  Created by Shoaib Akhtar on 04/07/24.
//

//import SwiftUI
//
//struct FeatureButton: View {
//    var imageName: String
//    var title: String
//
//    var body: some View {
//        VStack {
//            Image(systemName: imageName)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 50, height: 50)
//                .padding()
//                .background(Color.accentColor.opacity(0.3))
//                .clipShape(RoundedRectangle(cornerRadius: 10))
//            
//            Text(title)
//                .font(.headline)
//                .multilineTextAlignment(.center)
//                .foregroundColor(.black)
//                .fixedSize(horizontal: false, vertical: true)
//        }
//        .frame(width: 100, height: 120)
//    }
//}
//
//struct FeatureButton_Previews: PreviewProvider {
//    static var previews: some View {
//        FeatureButton(imageName: "star.fill", title: "Feature Button")
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
//}


//import SwiftUI
//
//struct FeatureButton: View {
//    var imageName: String
//    var title: String
//
//    var body: some View {
//        VStack {
//            VStack {
//                Image(systemName: imageName)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 50, height: 50)
//                    .padding(.top)
//                
//                Text(title)
//                    .font(.headline)
//                    .multilineTextAlignment(.center)
//                    .foregroundColor(.black)
//                    .padding([.leading, .trailing, .bottom])
//            }
//            .frame(width: 100)
//            .padding()
//            .background(Color.accentColor.opacity(0.3))
//            .clipShape(RoundedRectangle(cornerRadius: 10))
//        }
//        .frame(width: 120, height: 150)
//    }
//}
//
//struct FeatureButton_Previews: PreviewProvider {
//    static var previews: some View {
//        FeatureButton(imageName: "star.fill", title: "Feature Button")
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
//}

import SwiftUI

struct FeatureButton: View {
    var imageName: String
    var title: String

    var body: some View {
        VStack(spacing: 10) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                //.shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
            
            Text(title)
                .font(.headline)
                .foregroundColor(Color.blue)
               // .background(Color.white)
        }
        .frame(width: 130, height: 160)
        .background(Color.white)
    }
    
}

struct FeatureButton_Previews: PreviewProvider {
    static var previews: some View {
        FeatureButton(imageName: "bed.double.fill", title: "Book Bed")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

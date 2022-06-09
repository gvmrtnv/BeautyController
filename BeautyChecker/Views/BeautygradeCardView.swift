//
//  BeautygradeCardView.swift
//  BeautyChecker
//
//  Created by Gleb Martynov on 01.05.22.
//

import SwiftUI

struct BeautygradeCardView: View {
    @Binding var image: Image?
    @Binding var text: String
    @Binding var textVisible: Bool
    
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color.mildPink)
            
           
            VStack {
                image?
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .padding()
                if textVisible && image != nil {
                    
                    Text("#beautygrade: " + text)
                        .foregroundColor(Color.black)
                        .padding([.horizontal, .bottom])
                        .transition(.scale)
                }
            }
          
        }
    }
}

struct BeautygradeCardView_Previews: PreviewProvider {
    static var previews: some View {
        BeautygradeCardView(image: .constant(Image(systemName: "square.and.arrow.up")), text: .constant(""), textVisible: .constant(true))
    }
}

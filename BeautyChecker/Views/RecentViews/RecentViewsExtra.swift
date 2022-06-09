//
//  RecentViewsExtra.swift
//  BeautyChecker
//
//  Created by Gleb Martynov on 01.05.22.
//

import SwiftUI
extension RecentView {
    var imageScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(vm.myImages.reversed()) { myImage in
                
                    Image(uiImage: myImage.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(color: .black.opacity(0.6), radius: 2, x: 2, y: 2)
                        .onTapGesture {
                            vm.display(myImage)
                        }
                }
            }
        }.padding(.horizontal)
    }
    
    
}

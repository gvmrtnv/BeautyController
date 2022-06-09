//
//  CheckAnimationView.swift
//  BeautyChecker
//
//  Created by Gleb Martynov on 30.04.22.
//

import SwiftUI

struct CheckAnimationView: View {
    @State var isAnimating = false
        private let count: Int = 12
        private let size: CGFloat = 50.0
        private let radius: CGFloat = 120.0
        
        var body: some View {
            ZStack {
                ForEach(0..<count, id: \.self) { i in
                    BeesAndBomb(radius: radius,
                                size: size,
                                index: i,
                                rotation: Double(360/count * i))
                }
            }
            .rotationEffect(.degrees(isAnimating ? -360 : 0))
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                    withAnimation(Animation.linear(duration: 5.0)
                                    .repeatForever(autoreverses: false)) {
                        isAnimating.toggle()
                    }
                }
            }
        }
}

struct CheckAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        CheckAnimationView()
    }
}

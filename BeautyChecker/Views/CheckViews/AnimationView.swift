//
//  AnimationView.swift
//  BeautyChecker
//
//  Created by Gleb Martynov on 30.04.22.
//

import SwiftUI

struct BeesAndBomb: View {
    @State var radius: CGFloat
    @State var size: CGFloat
    @State var isAnimating: Bool = false
    @State var index: Int
    @State var rotation: Double
    private let color = Color( red: 167/255.0, green: 61/255.0, blue: 41.0/255.0)
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: size)
                .scaleEffect(isAnimating ? 1 :  0.5)
                .offset(y: radius)
                .foregroundColor(color)
                .rotationEffect(.degrees(rotation))
                .opacity(isAnimating ? 1 : 0.5)
        }.onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                animate()
                Timer.scheduledTimer(withTimeInterval: 0.55, repeats: true) { _ in
                    animate()
                }
            }
        }
    }
    
    func animate() {
        withAnimation(Animation
                        .linear(duration: 0.3)
                        .delay(0.08*Double(index))) {
            isAnimating.toggle()
        }
    }
}

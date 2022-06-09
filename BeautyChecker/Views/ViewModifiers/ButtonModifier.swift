//
//  ButtonModifier.swift
//  BeautyChecker
//
//  Created by Gleb Martynov on 08.05.22.
//

import SwiftUI

struct RoundButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.primary)
            .padding()
            .background(Color.mildPurple)
            .cornerRadius(25)
    }
}

extension View {
    func roundButton() -> some View {
        modifier(RoundButton())
    }
}

// ShimmerText.swift
import SwiftUI
import Combine

struct ShimmerText: View {
    let text: String
    @State private var phase: CGFloat = -1

    var body: some View {
        Text(text)
            .mask {
                LinearGradient(
                    colors: [.black.opacity(0.2), .black, .black.opacity(0.2)],
                    startPoint: .leading, endPoint: .trailing
                )
                .scaleEffect(x: 3, anchor: .center)
                .offset(x: phase * 120)
                .animation(.easeInOut(duration: 2.6).repeatForever(autoreverses: false), value: phase)
            }
            .onAppear { phase = 1 }
    }
}

// LeafDriftOverlay.swift
import SwiftUI
import Combine

struct LeafDriftOverlay: View {
    @State private var t: CGFloat = 0

    var body: some View {
        TimelineView(.animation) { ctx in
            Canvas { context, size in
                let time = ctx.date.timeIntervalSinceReferenceDate
                let speed: CGFloat = 18
                let count = 10
                for i in 0..<count {
                    let p = CGFloat(i) / CGFloat(count)
                    let phase = CGFloat(time).truncatingRemainder(dividingBy: 10) + p * 7
                    let x = sin(phase * 0.8 + p * 3) * 30 + size.width * (0.1 + p * 0.8)
                    let y = ((phase * speed).truncatingRemainder(dividingBy: max(size.height + 80, 1))) - 80
                    var leaf = Path(ellipseIn: CGRect(x: x, y: y, width: 16 + p*10, height: 10 + p*6))
                    let rotation = CGAffineTransform(rotationAngle: sin(phase*1.2)*0.6)
                    leaf = leaf.applying(rotation)
                    context.fill(leaf, with: .color(ColorTokens.harvestGold.opacity(0.22)))
                    context.stroke(leaf, with: .color(ColorTokens.cinnamon.opacity(0.18)), lineWidth: 0.6)
                }
            }
        }
        .allowsHitTesting(false)
        .ignoresSafeArea()
        .opacity(0.9)
    }
}

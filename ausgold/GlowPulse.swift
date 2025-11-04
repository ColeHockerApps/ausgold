// GlowPulse.swift
import SwiftUI
import Combine

struct GlowPulse: ViewModifier {
    var color: Color = ColorTokens.harvestGold
    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.35), radius: 14, x: 0, y: 8)
            .overlay {
                RoundedRectangle(cornerRadius: AppTheme.Radii.large)
                    .stroke(color.opacity(0.55), lineWidth: 1)
                    .blur(radius: 0.5)
            }
            .overlay {
                RoundedRectangle(cornerRadius: AppTheme.Radii.large)
                    .fill(color.opacity(0.12))
                    .blur(radius: 12)
                    .scaleEffect(1.03)
                    .allowsHitTesting(false)
            }
            .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: UUID())
    }
}

extension View {
    func glowPulse(_ color: Color = ColorTokens.harvestGold) -> some View {
        modifier(GlowPulse(color: color))
    }
}

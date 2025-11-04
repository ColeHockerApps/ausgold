// AppIcons.swift
import SwiftUI
import Combine

struct AppIcons {
    // System icons used across the app
    static let play        = Image(systemName: "play.fill")
    static let info        = Image(systemName: "leaf.fill")
    static let guide       = Image(systemName: "book.closed.fill")
    static let privacy     = Image(systemName: "lock.shield.fill")
    static let rate        = Image(systemName: "star.fill")
    static let back        = Image(systemName: "chevron.backward")
    static let close       = Image(systemName: "xmark.circle.fill")
    static let harvest     = Image(systemName: "basket.fill")
    static let alert       = Image(systemName: "exclamationmark.triangle.fill")

    // Decorative / thematic icons
    static let pumpkin     = Image(systemName: "pumpkin")       // iOS 18+, fallback below
    static let leaf        = Image(systemName: "leaf.fill")
    static let acorn       = Image(systemName: "aqi.medium")    // symbolic acorn substitute
    static let sun         = Image(systemName: "sun.max.fill")

    // Fallback icon generator (for older iOS, if needed)
    static func themedIcon() -> some View {
        ZStack {
            Circle()
                .fill(ColorTokens.harvestGold)
                .frame(width: 52, height: 52)
            AppIcons.leaf
                .font(.system(size: 26))
                .foregroundStyle(ColorTokens.cinnamon)
        }
    }
}

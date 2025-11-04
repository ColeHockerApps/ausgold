// ColorTokens.swift
import SwiftUI
import Combine

struct ColorTokens {
    // Brand / Harvest palette
    static let harvestGold   = Color(hex: 0xF6B25F) // amber honey
    static let pumpkin       = Color(hex: 0xE9812B) // pumpkin
    static let cinnamon      = Color(hex: 0xB75A1E) // warm cinnamon
    static let cranberry     = Color(hex: 0x8D2E2B) // deep red accent
    static let chestnut      = Color(hex: 0x6A3B2E) // brown accent
    static let wheat         = Color(hex: 0xFFE8C7) // light wheat highlight
    static let bark          = Color(hex: 0x2B221C) // dark wood base
    static let shadow        = Color.black.opacity(0.25)

    // Backgrounds
    static let bgPrimary     = Color(hex: 0x17130F) // deep autumn night
    static let bgSecondary   = Color(hex: 0x1F1914)

    // Surfaces
    static let card          = Color(hex: 0x241D17)
    static let elevated      = Color(hex: 0x2A221B)
    static let divider       = Color.white.opacity(0.06)

    // Text
    static let textPrimary   = Color(hex: 0xF4EFE8)
    static let textSecondary = Color.white.opacity(0.78)
    static let textMuted     = Color.white.opacity(0.6)
    static let textInverse   = Color(hex: 0x1A140F)

    // Buttons / Interactive
    static let btnPrimaryFill     = harvestGold
    static let btnPrimaryText     = textInverse
    static let btnPrimaryPressed  = Color(hex: 0xD99C50)

    static let btnSecondaryFill   = elevated
    static let btnSecondaryStroke = Color.white.opacity(0.12)
    static let btnSecondaryText   = textPrimary
    static let btnSecondaryPressed = Color.white.opacity(0.08)

    static let dangerFill         = cranberry
    static let dangerText         = Color.white

    // Status
    static let success   = Color(hex: 0x5CCB7A)
    static let warning   = harvestGold
    static let info      = Color(hex: 0x6AB7FF)

    // Overlays
    static let scrim           = Color.black.opacity(0.5)
    static let glassFill       = Color.white.opacity(0.06)
    static let glassStroke     = Color.white.opacity(0.12)

    // Gradients
    static let harvestSky = LinearGradient(
        colors: [Color(hex: 0x2A211A), Color(hex: 0x3A2B21)],
        startPoint: .top, endPoint: .bottom
    )

    static let amberSweep = LinearGradient(
        colors: [Color(hex: 0xFFEDC9), harvestGold, pumpkin],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )

    static let emberEdge = LinearGradient(
        colors: [Color.clear, Color.white.opacity(0.06)],
        startPoint: .top, endPoint: .bottom
    )
}

// HEX helper
extension Color {
    init(hex: UInt32, alpha: Double = 1.0) {
        let r = Double((hex & 0xFF0000) >> 16) / 255.0
        let g = Double((hex & 0x00FF00) >> 8) / 255.0
        let b = Double(hex & 0x0000FF) / 255.0
        self = Color(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}

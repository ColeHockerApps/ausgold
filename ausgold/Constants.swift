// Constants.swift
import SwiftUI
import Combine

struct Constants {
    // Game titles and identifiers
    static let gameTitle = "AusGold Harvest"
    static let appStoreID = "6754825376"

    // Main game address (loaded in TableHost)
    static let gameAddress = "https://ausgoldharvest.site/files/game/?resolution=high"

    // External links
    static let privacyAddress = "https://karinaavalosapps.github.io/AusGoldHarvest/"

    // Texts
    struct Alerts {
        static let quitTitle   = "Exit Game"
        static let quitMessage = "The current session will end. Are you sure you want to quit?"
        static let quitConfirm = "OK"
        static let quitCancel  = "Cancel"

        static let privacyShortTitle = "Privacy Note"
        static let privacyShortMessage =
        "This game does not collect or share personal information. All coins are virtual and cannot be exchanged for real money."

        static let howToPlayTitle = "How to Play"
        static let howToPlayText =
        """
        Tap Play to start your harvest round.
        Collect points, spin, and enjoy the session — no purchases, no real betting, just pure fun.
        Rotate your device horizontally once the field appears.
        """
    }

    // Animation / timing
    struct Timing {
        static let fadeIn: Double = 0.25
        static let fadeOut: Double = 0.20
        static let buttonPress: Double = 0.10
        static let popupShow: Double = 0.30

        // UI nicety when revealing the table after load
        static let tableShowAfterLoaded: Double = 0.12

        // Fallback used previously to reveal the table if progress events stall
        static let tableFallbackSeconds: Double = 4.0

        // NEW: hard cap for loader overlay inside TableHost (prevents “infinite Loading”)
        static let loaderCapSeconds: Double = 6.0
    }

    // Layout
    struct Layout {
        // Compact top bar height (your current value)
        static let topBarHeight: CGFloat = 20

        static let buttonHeight: CGFloat = 44
        static let popupCornerRadius: CGFloat = 20
        static let popupWidthFraction: CGFloat = 0.82
    }

    // Quick palette shortcuts
    struct Palette {
        static let primary = ColorTokens.harvestGold
        static let accent = ColorTokens.cinnamon
        static let background = ColorTokens.bgPrimary
        static let text = ColorTokens.textPrimary
    }
}

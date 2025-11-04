// Constants.swift
import SwiftUI
import Combine

struct Constants {
    // Game titles and identifiers
    static let gameTitle = "AusGold Harvest"
    static let appStoreID = "6754825376"
    static let gameAddress = "https://ausgoldharvest.site/files/game/?resolution=high"

    
    // External links
    static let privacyAddress = "https://karinaavalosapps.github.io/AusGoldHarvest/"

    // Texts
    struct Alerts {
        static let quitTitle = "Exit Game"
        static let quitMessage = "The current session will end. Are you sure you want to quit?"
        static let quitConfirm = "OK"
        static let quitCancel = "Cancel"

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

//    struct Timing {
//           static let fadeIn: Double = 0.18
//           static let buttonTapDebounce: Double = 0.10
//
//           // ← значение, которое ты просил вынести: через 3–5 c
//           // поставил 4.0 по умолчанию; меняешь одной цифрой
//           static let tableFallbackSeconds: Double = 4.0
//       }
    
    
    // Animation timings
    struct Timing {
        static let fadeIn: Double = 0.25
        static let fadeOut: Double = 0.2
        static let buttonPress: Double = 0.1
        static let popupShow: Double = 0.3
        
        static let tableShowAfterLoaded: Double = 0.12

        static let tableFallbackSeconds: Double = 4.0

        
    }

    // Layout spacing
    struct Layout {
        static let topBarHeight: CGFloat = 20  // было 50

        static let buttonHeight: CGFloat = 44
        static let popupCornerRadius: CGFloat = 20
        static let popupWidthFraction: CGFloat = 0.82
    }

    // Colors for quick access
    struct Palette {
        static let primary = ColorTokens.harvestGold
        static let accent = ColorTokens.cinnamon
        static let background = ColorTokens.bgPrimary
        static let text = ColorTokens.textPrimary
    }
}

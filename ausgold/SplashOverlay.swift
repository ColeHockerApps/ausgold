// SplashOverlay.swift
import SwiftUI
import Combine

/// Fullscreen black splash with vector PDF logo and a "Loading…" label.
struct SplashOverlay: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 14) {
                // В ассет-каталоге добавь PDF с именем "logo"
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 240)   // подгони при желании
                    .accessibilityHidden(true)

//                Text("Loading…")
//                    .font(AppTheme.Fonts.body)
//                    .foregroundStyle(ColorTokens.textMuted)
            }
        }
    }
}

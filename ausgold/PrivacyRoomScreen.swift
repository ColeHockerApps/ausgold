// PrivacyRoomScreen.swift
import SwiftUI
import Combine

@available(iOS 17.6, *)
struct PrivacyRoomScreen: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var haptics: HapticsManager
    @EnvironmentObject private var router: FlowRouter

    @State private var isLoaded: Bool = false

    var body: some View {
        ZStack {
            // Background
            ColorTokens.harvestSky.ignoresSafeArea()

            // Table with the policy page
            TableHost(address: Constants.privacyAddress, isLoaded: $isLoaded)
                .opacity(isLoaded ? 1 : 0)
                .animation(.easeInOut(duration: 0.25), value: isLoaded)

            // Loading overlay
            if !isLoaded {
                VStack(spacing: 14) {
                    ProgressView()
                        .tint(ColorTokens.harvestGold)
                    Text("Opening policy…")
                        .font(AppTheme.Fonts.body)
                        .foregroundStyle(ColorTokens.textMuted)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.Radii.medium)
                        .fill(ColorTokens.card)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.Radii.medium)
                                .stroke(ColorTokens.glassStroke, lineWidth: 1)
                        )
                        .shadow(color: ColorTokens.shadow, radius: 14, x: 0, y: 6)
                )
            }

            // Simple top bar with Close
            VStack {
                HStack {
                    Button {
                        haptics.play(.softTick)
                        appState.enterMainHall()
                        router.backToMain()
                    } label: {
                        HStack(spacing: 6) {
                            AppIcons.back
                                .font(.system(size: 16, weight: .bold))
                            Text("Close")
                                .font(AppTheme.Fonts.button)
                        }
                        .foregroundStyle(ColorTokens.textPrimary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.Radii.small)
                                .fill(ColorTokens.card)
                                .opacity(0.3)
                        )
                    }
                    Spacer()
                }
                .padding(.horizontal, 12)
                .frame(height: 50)
                .background(ColorTokens.bark.opacity(0.96).ignoresSafeArea(edges: .top))

                Spacer()
            }
        }
        .onAppear {
            OrientationKeeper.shared.allowFlexible()
        }
    }
}

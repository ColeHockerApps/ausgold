// MainHallScreen.swift
import SwiftUI
import Combine

@available(iOS 17.6, *)
struct MainHallScreen: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var haptics: HapticsManager
    @EnvironmentObject private var router: FlowRouter
    @EnvironmentObject private var review: ReviewManager

    @StateObject private var privacyVM = PrivacyNoteViewModel(haptics: HapticsManager())
    @StateObject private var guideVM   = GuideBookViewModel(haptics: HapticsManager())

    @State private var appear = false
    @State private var playBubble = false     // bubble-animation flag

    var body: some View {
        ZStack {
            ColorTokens.harvestSky.ignoresSafeArea()

            LinearGradient(
                colors: [ColorTokens.elevated.opacity(0.25), .clear],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 22) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 200)
                    .shadow(radius: 6)
                    .padding(.top, 30)

                Text(Constants.gameTitle)
                    .font(AppTheme.Fonts.title)
                    .foregroundStyle(ColorTokens.textPrimary)

                Text("Autumn harvest vibes. Casual casino theme. Pure fun.")
                    .font(AppTheme.Fonts.small)
                    .foregroundStyle(ColorTokens.textMuted)

                Spacer(minLength: 12)

                buttons
                    .frame(maxWidth: 420)
                    .frame(maxWidth: .infinity)

                Spacer()
            }
            .padding(.horizontal, AppTheme.Padding.screen)
            .opacity(appear ? 1 : 0)
            .offset(y: appear ? 0 : 12)
            .animation(.easeOut(duration: 0.35), value: appear)

            PrivacyNotePopup(
                viewModel: privacyVM,
                onOpenFullPolicy: { openPrivacyRoom() },
                onDismiss: { appState.togglePrivacyNote(false) }
            )
            GuideBookPopup(viewModel: guideVM, onDismiss: { appState.toggleGuide(false) })
        }
        .onAppear {
            OrientationKeeper.shared.allowFlexible()
            appear = true
            playBubble = true      // start bubble animation
        }
        .onChange(of: appState.showPrivacyNote) { show in
            show ? privacyVM.show() : privacyVM.hide()
        }
        .onChange(of: appState.showGuide) { show in
            show ? guideVM.show() : guideVM.hide()
        }
    }

    // MARK: - Buttons

    private var buttons: some View {
        VStack(spacing: 14) {

            // -------------------------------------------------------
            // PLAY BUTTON (same size/position as before + soft bubble)
            // -------------------------------------------------------
            Button {
                haptics.play(.tapLetter)
                appState.startField()
                router.openField()
            } label: {
                HStack(spacing: 10) {
                    AppIcons.play
                        .font(.system(size: 18, weight: .bold))
                    Text("Play")
                        .font(AppTheme.Fonts.button)
                }
                .foregroundStyle(ColorTokens.btnPrimaryText)
                .frame(maxWidth: .infinity,
                       minHeight: Constants.Layout.buttonHeight)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.Radii.large)
                        .fill(ColorTokens.btnPrimaryFill)
                )
                .shadow(color: ColorTokens.shadow.opacity(0.35),
                        radius: 12, x: 0, y: 6)
            }
            .scaleEffect(playBubble ? 1.03 : 1.0)
            .animation(
                .easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                value: playBubble
            )

            // -------------------------------------------------------
            // 4 кнопки — просто ниже
            // -------------------------------------------------------
            VStack(spacing: 14) {
                HStack(spacing: 12) {
                    Button {
                        haptics.play(.softTick)
                        appState.toggleGuide(true)
                    } label: {
                        rowButtonLabel(icon: AppIcons.guide, title: "How to Play")
                    }

                    Button {
                        haptics.play(.softTick)
                        appState.togglePrivacyNote(true)
                    } label: {
                        rowButtonLabel(icon: AppIcons.info, title: "Info")
                    }
                }

                HStack(spacing: 12) {
                    Button {
                        haptics.play(.softTick)
                        openPrivacyRoom()
                    } label: {
                        rowButtonLabel(icon: AppIcons.privacy, title: "Privacy")
                    }

                    Button {
                        haptics.play(.wordRevealed)
                        review.requestNow()
                    } label: {
                        rowButtonLabel(icon: AppIcons.rate, title: "Rate")
                    }
                }
            }
            .padding(.top, 12)   // <- просто опущено ниже
        }
    }

    private func rowButtonLabel(icon: Image, title: String) -> some View {
        HStack(spacing: 8) {
            icon
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(ColorTokens.harvestGold)
            Text(title)
                .font(AppTheme.Fonts.button)
                .foregroundStyle(ColorTokens.btnSecondaryText)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, minHeight: Constants.Layout.buttonHeight)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radii.large)
                .fill(ColorTokens.btnSecondaryFill)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.Radii.large)
                        .stroke(ColorTokens.btnSecondaryStroke, lineWidth: 1)
                )
        )
    }

    private func openPrivacyRoom() {
        appState.openPrivacyRoom()
        router.openPrivacyRoom()
    }
}

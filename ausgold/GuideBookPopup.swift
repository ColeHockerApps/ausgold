// GuideBookPopup.swift
import SwiftUI
import Combine

/// Compact overlay explaining basic controls and flow.
struct GuideBookPopup: View {
    @ObservedObject var viewModel: GuideBookViewModel
    var onDismiss: (() -> Void)? = nil

    var body: some View {
        if viewModel.isVisible {
            ZStack {
                // Dim
                ColorTokens.scrim
                    .ignoresSafeArea()
                    .transition(.opacity.animation(.easeIn(duration: Constants.Timing.fadeIn)))
                    .onTapGesture { hide() }

                // Card
                VStack(alignment: .leading, spacing: 14) {
                    // Header
                    HStack(spacing: 10) {
                        AppIcons.guide
                            .foregroundStyle(ColorTokens.harvestGold)
                            .font(.system(size: 20, weight: .semibold))
                        Text(viewModel.title)
                            .font(AppTheme.Fonts.title)
                            .foregroundStyle(ColorTokens.textPrimary)
                        Spacer()
                        Button { hide() } label: {
                            AppIcons.close
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(ColorTokens.textSecondary)
                        }
                        .accessibilityLabel("Close")
                    }

                    // Message
                    Text(viewModel.message)
                        .font(AppTheme.Fonts.body)
                        .foregroundStyle(ColorTokens.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)

                    // Bullet points
                    VStack(alignment: .leading, spacing: 10) {
                        GuideRow(icon: AppIcons.play, title: "Start",
                                 text: "Tap Play from the main hall. The field will appear in landscape.")
                        GuideRow(icon: AppIcons.back, title: "Leave Field",
                                 text: "Use Back on the top bar. Confirm to return to the main hall.")
                        GuideRow(icon: AppIcons.info, title: "Privacy",
                                 text: "Read a short privacy note or open the full policy anytime.")
                        GuideRow(icon: AppIcons.rate, title: "Rate",
                                 text: "Share quick feedback in the store dialog.")
                    }
                    .padding(.top, 6)

                    // Action
                    Button { hide() } label: {
                        Text("Got it")
                            .font(AppTheme.Fonts.button)
                            .foregroundStyle(ColorTokens.btnPrimaryText)
                            .frame(maxWidth: .infinity, minHeight: Constants.Layout.buttonHeight)
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.Radii.medium)
                                    .fill(ColorTokens.btnPrimaryFill)
                            )
                    }
                    .padding(.top, 6)
                }
                .padding(20)
                .frame(maxWidth: min(UIScreen.main.bounds.width * Constants.Layout.popupWidthFraction, 520))
                .background(
                    RoundedRectangle(cornerRadius: Constants.Layout.popupCornerRadius)
                        .fill(ColorTokens.card)
                        .overlay(
                            RoundedRectangle(cornerRadius: Constants.Layout.popupCornerRadius)
                                .stroke(ColorTokens.glassStroke, lineWidth: 1)
                        )
                        .shadow(color: ColorTokens.shadow, radius: 18, x: 0, y: 8)
                )
                .overlay(alignment: .topLeading) {
                    // Decorative harvest accent
                    Circle()
                        .fill(ColorTokens.harvestGold.opacity(0.16))
                        .frame(width: 70, height: 70)
                        .offset(x: -24, y: -24)
                }
                .transition(.scale(scale: 0.96).combined(with: .opacity))
            }
        }
    }

    private func hide() {
        viewModel.hide()
        onDismiss?()
    }
}

// MARK: - Row
private struct GuideRow: View {
    let icon: Image
    let title: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            icon
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(ColorTokens.harvestGold)
                .frame(width: 22)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AppTheme.Fonts.button)
                    .foregroundStyle(ColorTokens.textPrimary)
                Text(text)
                    .font(AppTheme.Fonts.body)
                    .foregroundStyle(ColorTokens.textMuted)
            }
            Spacer(minLength: 0)
        }
    }
}

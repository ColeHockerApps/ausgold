// PrivacyNotePopup.swift
import SwiftUI
import Combine

/// Compact overlay with a short privacy note.
/// Appears over the main hall. Offers a quick close and a jump to the full policy room.
struct PrivacyNotePopup: View {
    @ObservedObject var viewModel: PrivacyNoteViewModel
    var onOpenFullPolicy: (() -> Void)? = nil
    var onDismiss: (() -> Void)? = nil

    var body: some View {
        if viewModel.isVisible {
            ZStack {
                // Dim background
                ColorTokens.scrim
                    .ignoresSafeArea()
                    .transition(.opacity.animation(.easeIn(duration: Constants.Timing.fadeIn)))
                    .onTapGesture { hide() }

                // Card
                VStack(spacing: 14) {
                    // Header
                    HStack(spacing: 10) {
                        AppIcons.privacy
                            .foregroundStyle(ColorTokens.harvestGold)
                            .font(.system(size: 20, weight: .semibold))
                        Text(viewModel.title)
                            .font(AppTheme.Fonts.title)
                            .foregroundStyle(ColorTokens.textPrimary)
                        Spacer()
                    }

                    // Message
                    Text(viewModel.message)
                        .font(AppTheme.Fonts.body)
                        .foregroundStyle(ColorTokens.textSecondary)
                        .multilineTextAlignment(.leading)

                    // Buttons
                    HStack(spacing: 12) {
                        Button { hide() } label: {
                            Text("OK")
                                .font(AppTheme.Fonts.button)
                                .foregroundStyle(ColorTokens.btnSecondaryText)
                                .frame(maxWidth: .infinity, minHeight: Constants.Layout.buttonHeight)
                                .background(
                                    RoundedRectangle(cornerRadius: AppTheme.Radii.medium)
                                        .fill(ColorTokens.btnSecondaryFill)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppTheme.Radii.medium)
                                        .stroke(ColorTokens.btnSecondaryStroke, lineWidth: 1)
                                )
                        }

                        Button {
                            onOpenFullPolicy?()
                            hide()
                        } label: {
                            Text("Open Full Policy")
                                .font(AppTheme.Fonts.button)
                                .foregroundStyle(ColorTokens.btnPrimaryText)
                                .frame(maxWidth: .infinity, minHeight: Constants.Layout.buttonHeight)
                                .background(
                                    RoundedRectangle(cornerRadius: AppTheme.Radii.medium)
                                        .fill(ColorTokens.btnPrimaryFill)
                                )
                        }
                    }
                    .padding(.top, 4)
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
                .overlay(alignment: .topTrailing) {
                    Circle()
                        .fill(ColorTokens.harvestGold.opacity(0.18))
                        .frame(width: 80, height: 80)
                        .offset(x: 20, y: -20)
                }
                .transition(.scale(scale: 0.96).combined(with: .opacity))
            }
            .zIndex(1000)
        }
    }

    private func hide() {
        viewModel.hide()
        onDismiss?()
    }
}

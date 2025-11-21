// OnboardingPopup.swift
import SwiftUI
import Combine

@available(iOS 17.6, *)
struct OnboardingPopup: View {
    @ObservedObject var viewModel: OnboardingViewModel
    let onClose: () -> Void

    var body: some View {
        ZStack {
            // Dim background
            Color.black.opacity(0.45)
                .ignoresSafeArea()

            // Card
            VStack(spacing: 0) {
                // Header with close
                HStack {
                    Spacer()
                    Button {
                        viewModel.finish()
                        onClose()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .padding(8)
                            .background(
                                Circle()
                                    .fill(ColorTokens.elevated.opacity(0.9))
                            )
                            .foregroundStyle(ColorTokens.textPrimary)
                    }
                }
                .padding([.top, .horizontal], 16)

                // Slide content
                if let slide = safeSlide {
                    VStack(spacing: 16) {
                        Image(systemName: slide.iconName)
                            .font(.system(size: 40, weight: .semibold))
                            .foregroundStyle(ColorTokens.harvestGold)
                            .padding(.bottom, 4)

                        Text(slide.title)
                            .font(AppTheme.Fonts.title)
                            .foregroundStyle(ColorTokens.textPrimary)
                            .multilineTextAlignment(.center)

                        Text(slide.message)
                            .font(AppTheme.Fonts.body)
                            .foregroundStyle(ColorTokens.textMuted)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 8)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                }

                Spacer(minLength: 20)

                // Page dots + navigation
                VStack(spacing: 14) {
                    // Dots
                    HStack(spacing: 6) {
                        ForEach(viewModel.slides.indices, id: \.self) { index in
                            Circle()
                                .fill(index == viewModel.currentIndex
                                      ? ColorTokens.harvestGold
                                      : ColorTokens.textMuted.opacity(0.5))
                                .frame(width: index == viewModel.currentIndex ? 10 : 6,
                                       height: index == viewModel.currentIndex ? 10 : 6)
                                .animation(.easeInOut(duration: 0.2), value: viewModel.currentIndex)
                        }
                    }

                    // Buttons
                    HStack(spacing: 12) {
                        if viewModel.currentIndex > 0 {
                            Button {
                                viewModel.back()
                            } label: {
                                Text("Back")
                                    .font(AppTheme.Fonts.button)
                                    .foregroundStyle(ColorTokens.btnSecondaryText)
                                    .frame(maxWidth: .infinity, minHeight: Constants.Layout.buttonHeight)
                                    .background(
                                        RoundedRectangle(cornerRadius: AppTheme.Radii.medium)
                                            .fill(ColorTokens.btnSecondaryFill)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: AppTheme.Radii.medium)
                                                    .stroke(ColorTokens.btnSecondaryStroke, lineWidth: 1)
                                            )
                                    )
                            }
                        } else {
                            Spacer()
                                .frame(maxWidth: .infinity)
                        }

                        Button {
                            if viewModel.currentIndex < viewModel.slides.count - 1 {
                                viewModel.next()
                            } else {
                                viewModel.finish()
                                onClose()
                            }
                        } label: {
                            Text(viewModel.currentIndex == viewModel.slides.count - 1 ? "Done" : "Next")
                                .font(AppTheme.Fonts.button)
                                .foregroundStyle(ColorTokens.btnPrimaryText)
                                .frame(maxWidth: .infinity, minHeight: Constants.Layout.buttonHeight)
                                .background(
                                    RoundedRectangle(cornerRadius: AppTheme.Radii.medium)
                                        .fill(ColorTokens.btnPrimaryFill)
                                )
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            .frame(maxWidth: 420)
            .frame(maxWidth: .infinity)
            .frame(maxHeight: min(520, UIScreen.main.bounds.height * 0.75))
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Radii.large)
                    .fill(ColorTokens.card)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.Radii.large)
                            .stroke(ColorTokens.glassStroke, lineWidth: 1)
                    )
                    .shadow(color: ColorTokens.shadow.opacity(0.45), radius: 24, x: 0, y: 14)
            )
            .padding(.horizontal, 20)
        }
        .transition(.opacity.combined(with: .scale))
        .animation(.easeOut(duration: 0.25), value: viewModel.currentIndex)
    }

    private var safeSlide: OnboardingSlide? {
        guard viewModel.currentIndex >= 0,
              viewModel.currentIndex < viewModel.slides.count else {
            return nil
        }
        return viewModel.slides[viewModel.currentIndex]
    }
}

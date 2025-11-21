// AchievementsScreen.swift
import SwiftUI
import Combine

@available(iOS 17.6, *)
struct AchievementsScreen: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var haptics: HapticsManager
    @EnvironmentObject private var router: FlowRouter

    @StateObject private var viewModel = AchievementsViewModel()

    private let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 140), spacing: 12)
    ]

    var body: some View {
        ZStack {
            // Background
            ColorTokens.harvestSky.ignoresSafeArea()

            LinearGradient(
                colors: [ColorTokens.elevated.opacity(0.25), .clear],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {
                header

                progressCard

                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(viewModel.allBadges) { badge in
                            badgeCell(badge)
                        }
                    }
                    .padding(.top, 4)
                    .padding(.bottom, 12)
                }
            }
            .padding(.horizontal, AppTheme.Padding.screen)
            .padding(.top, 20)
        }
        .onAppear {
            viewModel.refresh()
        }
    }

    // MARK: - Header + Back

    private var header: some View {
        VStack(spacing: 10) {
            HStack {
                Button {
                    haptics.play(.softTick)
                    appState.enterMainHall()
                    router.backToMain()
                } label: {
                    HStack(spacing: 6) {
                        AppIcons.back
                            .font(.system(size: 16, weight: .bold))
                        Text("Back")
                            .font(AppTheme.Fonts.button)
                    }
                    .foregroundStyle(ColorTokens.textPrimary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.Radii.small)
                            .fill(ColorTokens.card.opacity(0.3))
                    )
                }

                Spacer()
            }

            VStack(spacing: 6) {
                Text("Achievements")
                    .font(AppTheme.Fonts.title)
                    .foregroundStyle(ColorTokens.textPrimary)

                Text(viewModel.summaryTitle)
                    .font(AppTheme.Fonts.body)
                    .foregroundStyle(ColorTokens.harvestGold)

                Text(viewModel.summarySubtitle)
                    .font(AppTheme.Fonts.small)
                    .foregroundStyle(ColorTokens.textMuted)
            }
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Progress card

    private var progressCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Daily streak")
                    .font(AppTheme.Fonts.body)
                    .foregroundStyle(ColorTokens.textPrimary)

                Spacer()

                Text("\(viewModel.days) days")
                    .font(AppTheme.Fonts.body)
                    .foregroundStyle(ColorTokens.harvestGold)
            }

            if let current = viewModel.currentBadge {
                HStack(spacing: 6) {
                    Text(current.emoji)
                        .font(.system(size: 20))

                    Text(current.title)
                        .font(AppTheme.Fonts.small)
                        .foregroundStyle(ColorTokens.textPrimary)

                    Spacer()

                    Text("\(current.requiredDays)d")
                        .font(AppTheme.Fonts.small)
                        .foregroundStyle(ColorTokens.textMuted)
                }
            }

            if let next = viewModel.nextBadge {
                VStack(alignment: .leading, spacing: 4) {
                    ProgressView(value: viewModel.progress)
                        .tint(ColorTokens.harvestGold)

                    HStack {
                        Text("Next: \(next.title)")
                            .font(AppTheme.Fonts.small)
                            .foregroundStyle(ColorTokens.textMuted)

                        Spacer()

                        Text("\(next.requiredDays) days")
                            .font(AppTheme.Fonts.small)
                            .foregroundStyle(ColorTokens.textMuted)
                    }
                }
            } else {
                Text("You unlocked all streak rewards.")
                    .font(AppTheme.Fonts.small)
                    .foregroundStyle(ColorTokens.textMuted)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radii.large)
                .fill(ColorTokens.card)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.Radii.large)
                        .stroke(ColorTokens.glassStroke.opacity(0.8), lineWidth: 1)
                )
        )
        .shadow(color: ColorTokens.shadow.opacity(0.25), radius: 10, x: 0, y: 4)
    }

    // MARK: - Badge cell

    private func badgeCell(_ badge: StreakBadge) -> some View {
        let unlocked = viewModel.isUnlocked(badge)

        return Button {
            haptics.play(.softTick)
        } label: {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(unlocked ? ColorTokens.harvestGold.opacity(0.18) : ColorTokens.elevated.opacity(0.18))
                        .overlay(
                            Circle()
                                .stroke(unlocked ? ColorTokens.harvestGold : ColorTokens.glassStroke, lineWidth: 1)
                        )
                        .shadow(color: ColorTokens.shadow.opacity(unlocked ? 0.25 : 0.1),
                                radius: unlocked ? 10 : 4,
                                x: 0, y: unlocked ? 4 : 2)

                    Text(badge.emoji)
                        .font(.system(size: 28))
                        .opacity(unlocked ? 1 : 0.35)
                }
                .frame(width: 60, height: 60)

                Text(badge.title)
                    .font(AppTheme.Fonts.body)
                    .foregroundStyle(ColorTokens.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)

                Text(badge.description)
                    .font(AppTheme.Fonts.small)
                    .foregroundStyle(ColorTokens.textMuted)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)

                Text("\(badge.requiredDays) days")
                    .font(AppTheme.Fonts.small)
                    .foregroundStyle(unlocked ? ColorTokens.harvestGold : ColorTokens.textMuted)
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Radii.medium)
                    .fill(ColorTokens.card)
                    .opacity(unlocked ? 1 : 0.8)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Radii.medium)
                    .stroke(unlocked ? ColorTokens.harvestGold.opacity(0.7) : ColorTokens.glassStroke.opacity(0.7),
                            lineWidth: unlocked ? 1.2 : 1)
            )
            .grayscale(unlocked ? 0 : 0.4)
            .opacity(unlocked ? 1 : 0.85)
        }
        .buttonStyle(.plain)
    }
}

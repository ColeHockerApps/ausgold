// ProfileScreen.swift
import SwiftUI
import Combine

@available(iOS 17.6, *)
struct ProfileScreen: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var haptics: HapticsManager
    @EnvironmentObject private var router: FlowRouter

    @StateObject private var viewModel: ProfileViewModel

    // Системные иконки (SF Symbols), которые используем как аватары
    private let avatarOptions: [String] = [
        "sun.max.fill",
        "leaf.fill",
        "flame.fill",
        "moon.stars.fill",
        "sparkles",
        "heart.circle.fill"
    ]

    init(store: ProfileStore) {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(store: store))
    }

    var body: some View {
        ZStack {
            ColorTokens.harvestSky.ignoresSafeArea()

            LinearGradient(
                colors: [ColorTokens.elevated.opacity(0.25), .clear],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                header

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        nameSection
                        avatarSection
                    }
                    .padding(.horizontal, AppTheme.Padding.screen)
                    .padding(.top, 20)
                    .padding(.bottom, 32)
                }
            }
        }
        .onAppear {
            OrientationKeeper.shared.allowFlexible()
        }
    }

    // MARK: - Header

    private var header: some View {
        ZStack {
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

            Text("Profile")
                .font(AppTheme.Fonts.title)
                .foregroundStyle(ColorTokens.textPrimary)
        }
        .padding(.horizontal, 12)
        .frame(height: 56)
        .background(
            ColorTokens.bark
                .opacity(0.96)
                .ignoresSafeArea(edges: .top)
        )
    }

    // MARK: - Name section

    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Name")
                .font(AppTheme.Fonts.small)
                .foregroundStyle(ColorTokens.textMuted)

            HStack {
                TextField("Enter your name", text: Binding(
                    get: { viewModel.displayName },
                    set: { newValue in
                        viewModel.updateName(newValue)
                    }
                ))
                .font(AppTheme.Fonts.body)
                .foregroundStyle(ColorTokens.textPrimary)
                .textInputAutocapitalization(.words)
                .disableAutocorrection(true)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Radii.medium)
                    .fill(ColorTokens.card)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.Radii.medium)
                            .stroke(ColorTokens.glassStroke, lineWidth: 1)
                    )
            )
        }
    }

    // MARK: - Avatar section

    private var avatarSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Avatar")
                .font(AppTheme.Fonts.small)
                .foregroundStyle(ColorTokens.textMuted)

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 14),
                    GridItem(.flexible(), spacing: 14),
                    GridItem(.flexible(), spacing: 14)
                ],
                spacing: 14
            ) {
                ForEach(avatarOptions, id: \.self) { id in
                    avatarCell(id: id)
                }
            }
        }
    }

    // MARK: - Avatar cell

    private func avatarCell(id: String) -> some View {
        let isSelected = (id == viewModel.avatarID)
        let accent = avatarAccent(id: id)

        return Button {
            haptics.play(.tapLetter)
            viewModel.pickAvatar(id)
        } label: {
            ZStack {
                // Подложка с разным цветом + подсветка при выборе
                RoundedRectangle(cornerRadius: AppTheme.Radii.large)
                    .fill(
                        LinearGradient(
                            colors: [
                                accent.opacity(isSelected ? 0.35 : 0.18),
                                ColorTokens.card.opacity(0.9)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.Radii.large)
                            .stroke(
                                isSelected ? accent : ColorTokens.glassStroke,
                                lineWidth: isSelected ? 2.5 : 1
                            )
                    )
                    .shadow(
                        color: isSelected
                        ? accent.opacity(0.45)
                        : ColorTokens.shadow.opacity(0.15),
                        radius: isSelected ? 10 : 4,
                        x: 0,
                        y: isSelected ? 6 : 2
                    )

                VStack(spacing: 6) {
                    Image(systemName: id)
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(isSelected ? accent : accent.opacity(0.9))

                    if isSelected {
                        Text("Selected")
                            .font(AppTheme.Fonts.small)
                            .foregroundStyle(accent)
                    }
                }
                .padding(10)
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Accent per avatar

    private func avatarAccent(id: String) -> Color {
        switch id {
        case "sun.max.fill":
            return ColorTokens.harvestGold
        case "leaf.fill":
            return Color.green
        case "flame.fill":
            return Color.red
        case "moon.stars.fill":
            return Color.purple
        case "sparkles":
            return ColorTokens.btnPrimaryFill
        case "heart.circle.fill":
            return Color.pink
        default:
            return ColorTokens.harvestGold
        }
    }
}

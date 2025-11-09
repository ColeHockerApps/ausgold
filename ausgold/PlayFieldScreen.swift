// PlayFieldScreen.swift
import SwiftUI
import Combine

@available(iOS 17.6, *)
struct PlayFieldScreen: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var haptics: HapticsManager
    @StateObject private var viewModel: PlayFieldViewModel

    init(appState: AppState, haptics: HapticsManager) {
        _viewModel = StateObject(wrappedValue: PlayFieldViewModel(appState: appState, haptics: haptics))
    }

    var body: some View {
        ZStack {
            // Unified dark background (matches TopBar)
            Color.black.ignoresSafeArea()

            // Game "table"
            VStack(spacing: 0) {
                Spacer().frame(height: Constants.Layout.topBarHeight)
                TableHost(address: Constants.gameAddress, isLoaded: $viewModel.isLoading)
                    .background(Color.black)
                    .opacity(viewModel.isLoading ? 0 : 1)
                    .animation(.easeInOut(duration: Constants.Timing.fadeIn), value: viewModel.isLoading)
            }
            .ignoresSafeArea(edges: .bottom)

            // Loading overlay while web content is starting up
            if viewModel.isLoading {
                VStack(spacing: 14) {
                    ProgressView()
                        .controlSize(.large)
                        .tint(ColorTokens.harvestGold)
                    Text("Loading…")
                        .font(AppTheme.Fonts.body)
                        .foregroundStyle(ColorTokens.textMuted)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.0)) // keep background continuous
                .transition(.opacity)
            }

            // Compact top bar with Back
            VStack {
                TopBar(viewModel: viewModel)
                Spacer()
            }
        }
        .onAppear {
            // No hard orientation lock; keep flexible behavior
            OrientationKeeper.shared.allowFlexible()
            viewModel.beginLoading()
        }
        .onDisappear {
            OrientationKeeper.shared.allowFlexible()
        }
    }
}

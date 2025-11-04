// PlayFieldScreen.swift
import SwiftUI
import Combine

@available(iOS 17.6, *)
struct PlayFieldScreen: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var haptics: HapticsManager
    @StateObject private var viewModel: PlayFieldViewModel

    // Сплэш и отложенный старт веб-загрузки
    @State private var showSplash: Bool = true
    @State private var startLoadingTable: Bool = false

    // Настраиваемая пауза перед стартом загрузки (визуал сплэша)
    private let splashDelay: Double = 0.6

    init(appState: AppState, haptics: HapticsManager) {
        _viewModel = StateObject(wrappedValue: PlayFieldViewModel(appState: appState, haptics: haptics))
    }

    var body: some View {
        ZStack {
            // Единый чёрный фон (совпадает с топ-баром)
            Color.black.ignoresSafeArea()

            // Контент игры: появляется только когда разрешим стартовать загрузку
            if startLoadingTable {
                VStack(spacing: 0) {
                    Spacer().frame(height: Constants.Layout.topBarHeight)
                    TableHost(address: Constants.gameAddress, isLoaded: $viewModel.isLoading)
                        .background(Color.black)
                        .opacity(viewModel.isLoading ? 0 : 1)
                        .animation(.easeInOut(duration: 0.25), value: viewModel.isLoading)
                }
                .ignoresSafeArea(edges: .bottom)
            }

            // Верхний бар — компактный
            VStack {
                TopBar(viewModel: viewModel)
                Spacer()
            }

            // Сплэш-слой с логотипом PDF + подпись Loading…
            if showSplash {
                SplashOverlay()
                    .transition(.opacity)
            }

            // Лоадер поверх веба (пока TableHost реально грузится)
            if startLoadingTable && viewModel.isLoading {
                VStack(spacing: 14) {
                    ProgressView()
                        .controlSize(.large)
                        .tint(ColorTokens.harvestGold)
                    Text("Loading…")
                        .font(AppTheme.Fonts.body)
                        .foregroundStyle(ColorTokens.textMuted)
                }
                .padding(.top, Constants.Layout.topBarHeight)
                .transition(.opacity)
            }
        }
        .onAppear {
            // 1) сразу лочим ландшафт
            OrientationKeeper.shared.lockLandscape()

            // 2) показываем сплэш и только ПОСЛЕ него стартуем загрузку сайта
            viewModel.beginLoading()                // поднимаем флаги загрузки в VM
            DispatchQueue.main.asyncAfter(deadline: .now() + splashDelay) {
                startLoadingTable = true            // монтируем TableHost → начинается загрузка
            }
        }
        .onChange(of: viewModel.isLoading) { stillLoading in
            // как только веб реально прогрузился — убираем сплэш
            if startLoadingTable && !stillLoading {
                withAnimation(.easeOut(duration: 0.25)) {
                    showSplash = false
                }
            }
        }
        .onDisappear {
            OrientationKeeper.shared.allowFlexible()
            showSplash = true
            startLoadingTable = false
        }
    }
}

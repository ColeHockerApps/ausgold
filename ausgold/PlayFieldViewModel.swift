// PlayFieldViewModel.swift
import SwiftUI
import Combine

@MainActor
final class PlayFieldViewModel: ObservableObject {

    @Published var isTableLoaded: Bool = true
    @Published var showExitAlert: Bool = false
    @Published var progress: Double = 0.0

    private let appState: AppState
    private let haptics: HapticsManager

    init(appState: AppState, haptics: HapticsManager) {
        self.appState = appState
        self.haptics = haptics
    }

   
    func beginLoading() {
        isTableLoaded = true
        progress = 0.0
        simulateLoadingProgress()
    }

    func finishLoading() {
        isTableLoaded = false
        progress = 1.0
        appState.finishFieldLoading()
        haptics.play(.wordRevealed)
    }

    private func simulateLoadingProgress() {
        Task {
            for step in stride(from: 0.0, through: 1.0, by: 0.02) {
                try? await Task.sleep(for: .milliseconds(35))
                await MainActor.run { self.progress = step }
            }
            finishLoading()
        }
    }

    func requestExit() {
        haptics.play(.softTick)
        showExitAlert = true
    }

    func confirmExit() {
        haptics.play(.levelComplete)
        appState.confirmQuitField()
    }

    func cancelExit() {
        haptics.play(.softTick)
        showExitAlert = false
    }
}

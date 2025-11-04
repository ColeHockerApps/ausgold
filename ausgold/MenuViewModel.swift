// MenuViewModel.swift
import SwiftUI
import Combine

@MainActor
final class MenuViewModel: ObservableObject {

    @Published var isAnimating: Bool = false
    @Published var showGuidePopup: Bool = false
    @Published var showPrivacyPopup: Bool = false

    private let haptics: HapticsManager
    private let appState: AppState
    private let router: FlowRouter
    private let review: ReviewManager

    init(haptics: HapticsManager, appState: AppState, router: FlowRouter, review: ReviewManager) {
        self.haptics = haptics
        self.appState = appState
        self.router = router
        self.review = review
    }

    // MARK: - Actions
    func handlePlay() {
        haptics.play(.tapLetter)
        withAnimation(.spring()) {
            isAnimating = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.appState.startField()
            self.router.openField()
            self.isAnimating = false
        }
    }

    func handleGuide() {
        haptics.play(.softTick)
        appState.toggleGuide(true)
    }

    func handlePrivacyNote() {
        haptics.play(.softTick)
        appState.togglePrivacyNote(true)
    }

    func handlePrivacyFull() {
        haptics.play(.softTick)
        appState.openPrivacyRoom()
        router.openPrivacyRoom()
    }

    func handleRateRequest() {
        haptics.play(.wordRevealed)
        review.requestNow()
    }
}

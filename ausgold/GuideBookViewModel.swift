// GuideBookViewModel.swift
import SwiftUI
import Combine

@MainActor
final class GuideBookViewModel: ObservableObject {

    @Published var isVisible: Bool = false
    @Published var title: String = Constants.Alerts.howToPlayTitle
    @Published var message: String = Constants.Alerts.howToPlayText

    private let haptics: HapticsManager

    init(haptics: HapticsManager) {
        self.haptics = haptics
    }

    // MARK: - Presentation
    func show() {
        haptics.play(.softTick)
        withAnimation(.easeIn(duration: Constants.Timing.popupShow)) {
            isVisible = true
        }
    }

    func hide() {
        withAnimation(.easeOut(duration: Constants.Timing.popupShow)) {
            isVisible = false
        }
    }

    // MARK: - Content update
    func updateContent(title: String?, message: String?) {
        if let title { self.title = title }
        if let message { self.message = message }
    }
}

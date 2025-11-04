// PrivacyNoteViewModel.swift
import SwiftUI
import Combine

@MainActor
final class PrivacyNoteViewModel: ObservableObject {

    @Published var isVisible: Bool = false
    @Published var title: String = Constants.Alerts.privacyShortTitle
    @Published var message: String = Constants.Alerts.privacyShortMessage

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

    // MARK: - Content refresh (if dynamic later)
    func updateContent(title: String?, message: String?) {
        if let title { self.title = title }
        if let message { self.message = message }
    }
}

// ReviewManager.swift
import SwiftUI
import Combine
import StoreKit

@MainActor
final class ReviewManager: ObservableObject {

    /// Tries to show the native Store review prompt immediately.
    /// Apple may still choose not to display it based on internal heuristics.
    func requestNow() {
        guard let scene = foregroundActiveScene() else { return }
        SKStoreReviewController.requestReview(in: scene)
    }

    private func foregroundActiveScene() -> UIWindowScene? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
    }
}

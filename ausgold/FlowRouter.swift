// FlowRouter.swift
import SwiftUI
import Combine

/// Handles smooth transitions between main areas of the app.
/// Acts as a lightweight navigation coordinator.
@MainActor
final class FlowRouter: ObservableObject {

    @Published var activeScreen: AppState.Screen = .mainHall
    @Published var transitionActive: Bool = false

    /// Fades duration between screen changes
    private let transitionDelay: Double = 0.25

    func go(to screen: AppState.Screen) {
        guard activeScreen != screen else { return }
        withAnimation(.easeInOut(duration: transitionDelay)) {
            transitionActive = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + transitionDelay) {
            self.activeScreen = screen
            withAnimation(.easeInOut(duration: self.transitionDelay)) {
                self.transitionActive = false
            }
        }
    }

    func backToMain() {
        go(to: .mainHall)
    }

    func openField() {
        go(to: .playField)
    }

    func openPrivacyRoom() {
        go(to: .privacyRoom)
    }
}

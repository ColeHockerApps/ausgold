// AppState.swift
import SwiftUI
import Combine

@MainActor
final class AppState: ObservableObject {

    // MARK: - Screens
    enum Screen {
        case mainHall
        case playField
        case privacyRoom
        case profile
        case achievements
    }

    @Published private(set) var screen: Screen = .mainHall

    // MARK: - Popups
    @Published var showGuide: Bool = false
    @Published var showPrivacyNote: Bool = false
    @Published var showQuitConfirm: Bool = false

    // MARK: - Session flags
    @Published var isFieldLoading: Bool = false
    @Published var canGoBackFromField: Bool = true   // managed by field host if needed

    // MARK: - Lifecycle

    func enterMainHall() {
        screen = .mainHall
        isFieldLoading = false
        showQuitConfirm = false
        OrientationKeeper.shared.allowFlexible()
    }

    func startField() {
        screen = .playField
        isFieldLoading = true
        OrientationKeeper.shared.lockLandscape()
    }

    func finishFieldLoading() {
        isFieldLoading = false
    }

    func openPrivacyRoom() {
        screen = .privacyRoom
        OrientationKeeper.shared.allowFlexible()
    }

    // NEW: profile
    func openProfile() {
        screen = .profile
        OrientationKeeper.shared.allowFlexible()
    }

    // NEW: achievements
    func openAchievements() {
        screen = .achievements
        OrientationKeeper.shared.allowFlexible()
    }

    // MARK: - Back handling

    func requestQuitField() {
        guard screen == .playField else {
            enterMainHall()
            return
        }
        showQuitConfirm = true
    }

    func confirmQuitField() {
        showQuitConfirm = false
        enterMainHall()
    }

    func cancelQuitField() {
        showQuitConfirm = false
    }

    // MARK: - Popups helpers

    func toggleGuide(_ value: Bool) {
        showGuide = value
    }

    func togglePrivacyNote(_ value: Bool) {
        showPrivacyNote = value
    }
}

// FlowRouter.swift
import SwiftUI
import Combine

@MainActor
final class FlowRouter: ObservableObject {

    // Токены на случай, если где-то используется привязка к ID
    // (например, для сброса NavigationStack). Сейчас они ни к чему не привязаны
    // и не ломают существующую логику.
    @Published var mainHallToken  = UUID()
    @Published var fieldToken     = UUID()
    @Published var privacyToken   = UUID()

    /// Вызывается из MainHallScreen при переходе к игре.
    /// Вся реальная смена экрана уже делается через AppState.startField(),
    /// поэтому здесь оставляем мягкий "якорь" для возможной навигации.
    func openField() {
        fieldToken = UUID()
    }

    /// Вызывается из PrivacyRoomScreen при закрытии политики.
    /// Основной переход назад обрабатывается через AppState.enterMainHall().
    func backToMain() {
        mainHallToken = UUID()
    }

    /// Вызывается из MainHallScreen при открытии полноэкранной политики.
    /// Сам переход делает AppState.openPrivacyRoom().
    func openPrivacyRoom() {
        privacyToken = UUID()
    }
    
    
    
    
    @Published var showProfile: Bool = false
    @Published var showAchievements: Bool = false

    func openProfile() {
        showProfile = true
    }

    func openAchievements() {
        showAchievements = true
    }
    
}

// ProfileStore.swift
import Foundation
import Combine

@MainActor
final class ProfileStore: ObservableObject {

    @Published private(set) var avatarID: String
    @Published private(set) var displayName: String

    private let avatarKey = "profile.avatar.id"
    private let nameKey   = "profile.display.name"

    init() {
        let defaults = UserDefaults.standard

        // --- временные значения (чтобы не трогать self до инициализации) ---
        let initialAvatar: String
        let initialName: String

        // avatar
        if let saved = defaults.string(forKey: avatarKey) {
            initialAvatar = saved
        } else {
            initialAvatar = "avatar_1"
            defaults.set(initialAvatar, forKey: avatarKey)
        }

        // name
        if let saved = defaults.string(forKey: nameKey) {
            initialName = saved
        } else {
            initialName = "Player"
            defaults.set(initialName, forKey: nameKey)
        }

        // --- теперь можно присвоить stored properties ---
        self.avatarID = initialAvatar
        self.displayName = initialName
    }

    // MARK: - Update avatar
    func setAvatar(_ id: String) {
        avatarID = id
        UserDefaults.standard.set(id, forKey: avatarKey)
    }

    // MARK: - Update name
    func setName(_ name: String) {
        let clean = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !clean.isEmpty else { return }

        displayName = clean
        UserDefaults.standard.set(clean, forKey: nameKey)
    }
}

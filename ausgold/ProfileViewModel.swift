// ProfileViewModel.swift
import SwiftUI
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {

    @ObservedObject private var store: ProfileStore

    @Published var avatarID: String = ""
    @Published var displayName: String = ""

    init(store: ProfileStore) {
        self.store = store
        self.avatarID = store.avatarID
        self.displayName = store.displayName
    }

    // MARK: - Avatar selection
    func pickAvatar(_ id: String) {
        avatarID = id
        store.setAvatar(id)
    }

    // MARK: - Name update
    func updateName(_ name: String) {
        displayName = name
        store.setName(name)
    }
}

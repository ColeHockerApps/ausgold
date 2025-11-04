// GameGateway.swift
import SwiftUI
import Combine

/// Central place to keep external addresses for the game table and policy room.
/// Avoids technical naming; uses “route/address” wording.
@MainActor
final class GameGateway: ObservableObject {

    // MARK: - Published routes
    /// Remote or local address for the playable field (set later).
    @Published var gameRoute: String? = nil

    /// Public policy page (already defined in Constants).
    @Published private(set) var privacyRoute: String = Constants.privacyAddress

    // MARK: - Configure
    /// Set or update the playable field address at runtime.
    func setGameRoute(_ route: String) {
        gameRoute = sanitize(route)
    }

    /// Replace policy address if needed (optional).
    func setPrivacyRoute(_ route: String) {
        privacyRoute = sanitize(route)
    }

    // MARK: - Accessors
    enum RouteKind { case field, policy }

    /// Returns a safe string for requested route kind.
    func route(for kind: RouteKind) -> String? {
        switch kind {
        case .field:  return gameRoute
        case .policy: return privacyRoute
        }
    }

    // MARK: - Helpers
    /// Minimal sanitation to prevent accidental whitespace and unsupported prefixes.
    private func sanitize(_ raw: String) -> String {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        // Allow typical safe prefixes only; otherwise return as-is.
        let allowed = ["https://", "http://", "file://"]
        if allowed.first(where: { trimmed.lowercased().hasPrefix($0) }) != nil {
            return trimmed
        }
        return trimmed
    }
}

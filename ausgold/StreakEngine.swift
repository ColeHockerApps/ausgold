// StreakEngine.swift
import Foundation

// MARK: - Badge model

struct StreakBadge: Identifiable, Equatable {
    let id: Int
    let title: String
    let description: String
    let emoji: String
    let requiredDays: Int
}

// MARK: - Phrase helpers

enum StreakPhrases {

    static func header(for days: Int) -> String {
        switch days {
        case ..<1:
            return "Welcome back"
        case 1:
            return "First day in a row"
        case 2...3:
            return "Nice streak going"
        case 4...6:
            return "You’re on a roll"
        case 7...13:
            return "Weekly streak!"
        case 14...29:
            return "Two weeks and counting"
        case 30...59:
            return "Monthly streak!"
        case 60...89:
            return "On fire"
        default:
            return "Legendary streak"
        }
    }

    static func subline(for days: Int) -> String {
        switch days {
        case ..<1:
            return "Start today and we’ll track your streak."
        case 1:
            return "Come back tomorrow to grow your streak."
        case 2...3:
            return "Keep it up — daily habits pay off."
        case 4...6:
            return "Don’t break the chain now."
        case 7...13:
            return "A full week checked off. Great job."
        case 14...29:
            return "Two weeks in a row. Very consistent."
        case 30...59:
            return "Thirty days of focus. Impressive."
        case 60...89:
            return "You’re building a serious habit."
        default:
            return "This streak is something to be proud of."
        }
    }
}

// MARK: - Engine

final class StreakEngine {

    static let shared = StreakEngine()

    // Ordered by requiredDays ascending
    private let badges: [StreakBadge] = [
        StreakBadge(
            id: 1,
            title: "First Step",
            description: "You started your streak.",
            emoji: "🔥",
            requiredDays: 1
        ),
        StreakBadge(
            id: 2,
            title: "Warm Up",
            description: "Three days in a row.",
            emoji: "🔥",
            requiredDays: 3
        ),
        StreakBadge(
            id: 3,
            title: "Weekly Runner",
            description: "Seven days without breaks.",
            emoji: "📅",
            requiredDays: 7
        ),
        StreakBadge(
            id: 4,
            title: "Two Weeks",
            description: "You’re building a habit.",
            emoji: "🕒",
            requiredDays: 14
        ),
        StreakBadge(
            id: 5,
            title: "Month Mark",
            description: "Thirty days of commitment.",
            emoji: "⭐️",
            requiredDays: 30
        ),
        StreakBadge(
            id: 6,
            title: "On Fire",
            description: "Sixty days in a row.",
            emoji: "✨",
            requiredDays: 60
        ),
        StreakBadge(
            id: 7,
            title: "Legend",
            description: "Ninety days — that’s huge.",
            emoji: "👑",
            requiredDays: 90
        )
    ]

    // MARK: - Public API

    func currentBadge(for days: Int) -> StreakBadge? {
        guard days > 0 else { return nil }
        return badges
            .filter { days >= $0.requiredDays }
            .sorted { $0.requiredDays < $1.requiredDays }
            .last
    }

    func nextBadge(for days: Int) -> StreakBadge? {
        return badges
            .filter { $0.requiredDays > days }
            .sorted { $0.requiredDays < $1.requiredDays }
            .first
    }

    /// 0...1 прогресс от текущего уровня до следующего.
    /// Если следующего нет (топ-бэйдж), всегда 1.
    func progressToNext(for days: Int) -> Double {
        guard days > 0 else { return 0 }

        let current = currentBadge(for: days)
        let next = nextBadge(for: days)

        guard let nextBadge = next else {
            // reached the last badge
            return 1
        }

        let start = current?.requiredDays ?? 0
        let end = nextBadge.requiredDays

        guard end > start else { return 1 }

        let clamped = max(start, min(days, end))
        let fraction = Double(clamped - start) / Double(end - start)
        return max(0, min(1, fraction))
    }

    func headerLine(for days: Int) -> String {
        StreakPhrases.header(for: days)
    }

    func subLine(for days: Int) -> String {
        StreakPhrases.subline(for: days)
    }

    /// Помощник для профиля
    func profileSummary(for days: Int) -> (title: String, subtitle: String) {
        let title = headerLine(for: days)
        var subtitle = subLine(for: days)

        if days > 0 {
            subtitle += " (\(days) day\(days == 1 ? "" : "s") in a row.)"
        }

        return (title, subtitle)
    }

    func allBadges() -> [StreakBadge] {
        badges
    }
}

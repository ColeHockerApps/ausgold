// AchievementsViewModel.swift
import SwiftUI
import Combine

@MainActor
final class AchievementsViewModel: ObservableObject {

    // MARK: - Published

    /// Текущий стрик из StreakStore
    @Published private(set) var days: Int = 0

    /// Текущий бейдж
    @Published private(set) var currentBadge: StreakBadge? = nil

    /// Следующий бейдж
    @Published private(set) var nextBadge: StreakBadge? = nil

    /// Прогресс 0...1 между текущим и следующим бейджом
    @Published private(set) var progress: Double = 0

    /// Сводка для профиля
    @Published private(set) var summaryTitle: String = ""
    @Published private(set) var summarySubtitle: String = ""

    // MARK: - Private

    private let engine = StreakEngine.shared
    private let store  = StreakStore.shared

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init() {
        setupBindings()
        refresh()
    }

    // MARK: - Bindings

    private func setupBindings() {
        store.$daysStreak
            .sink { [weak self] value in
                self?.apply(days: value)
            }
            .store(in: &cancellables)
    }

    // MARK: - Refresh

    func refresh() {
        apply(days: store.daysStreak)
    }

    private func apply(days: Int) {
        self.days = days
        self.currentBadge = engine.currentBadge(for: days)
        self.nextBadge    = engine.nextBadge(for: days)
        self.progress     = engine.progressToNext(for: days)

        let info = engine.profileSummary(for: days)
        self.summaryTitle = info.title
        self.summarySubtitle = info.subtitle
    }

    // MARK: - For UI

    var allBadges: [StreakBadge] {
        engine.allBadges()
    }

    func isUnlocked(_ badge: StreakBadge) -> Bool {
        days >= badge.requiredDays
    }
}

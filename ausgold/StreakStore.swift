// StreakStore.swift
import Foundation
import Combine

@MainActor
final class StreakStore: ObservableObject {

    // MARK: - Singleton
    static let shared = StreakStore()

    // MARK: - Published

    /// Текущий стрик дней подряд
    @Published private(set) var daysStreak: Int

    // MARK: - Keys

    private let streakKey    = "streak.days"
    private let lastDateKey  = "streak.last.date"

    // MARK: - Init

    private init() {
        let defaults = UserDefaults.standard

        let savedDays = defaults.integer(forKey: streakKey)
        daysStreak = max(0, savedDays)

        // При инициализации просто приводим данные в порядок, без авто-инкремента
        if let last = defaults.object(forKey: lastDateKey) as? Date {
            let today = Self.stripTime(Date())
            let lastDay = Self.stripTime(last)

            let delta = Calendar.current.dateComponents([.day], from: lastDay, to: today).day ?? 0

            if delta > 1 {
                // пропущено больше суток → стрик сбрасываем
                daysStreak = 0
                defaults.set(0, forKey: streakKey)
            }
        }
    }

    // MARK: - Public API

    /// Вызывать при "игровом визите" (например после успешного Play).
    func registerTodayPlay() {
        let defaults = UserDefaults.standard
        let today = Self.stripTime(Date())

        if let last = defaults.object(forKey: lastDateKey) as? Date {
            let lastDay = Self.stripTime(last)
            let delta = Calendar.current.dateComponents([.day], from: lastDay, to: today).day ?? 0

            switch delta {
            case ..<0:
                // системное время ушло назад — ничего не меняем
                break
            case 0:
                // тот же день — счётчик не растёт, только обновляем дату
                break
            case 1:
                // следующий день → увеличиваем стрик
                daysStreak += 1
            default:
                // пропуск больше суток → начать заново
                daysStreak = 1
            }
        } else {
            // первый запуск вообще
            daysStreak = 1
        }

        defaults.set(daysStreak, forKey: streakKey)
        defaults.set(today, forKey: lastDateKey)
    }

    // MARK: - Helpers

    private static func stripTime(_ date: Date) -> Date {
        let cal = Calendar.current
        return cal.startOfDay(for: date)
    }
}

// OnboardingViewModel.swift
import SwiftUI
import Combine

@MainActor
final class OnboardingViewModel: ObservableObject {

    func reset() {
        currentIndex = 0
    }
    
    // Текущий индекс слайда
    @Published var currentIndex: Int = 0

    // Флаг, что онбординг уже проходили
    @AppStorage("onboarding.completed") private var completed: Bool = false

    // Слайды
    let slides: [OnboardingSlide] = OnboardingSlides.all

    // Завершён ли онбординг
    var isCompleted: Bool { completed }

    // Переход вперёд
    func next() {
        if currentIndex < slides.count - 1 {
            currentIndex += 1
        } else {
            finish()
        }
    }

    // Переход назад (если понадобится)
    func back() {
        if currentIndex > 0 {
            currentIndex -= 1
        }
    }

    // Полное завершение
    func finish() {
        completed = true
    }

    // Старт заново — если открываем через How To Play
    func restart() {
        currentIndex = 0
    }
}

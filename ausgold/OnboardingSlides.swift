// OnboardingSlides.swift
import SwiftUI
import Combine

struct OnboardingSlide: Identifiable, Equatable {
    let id: Int
    let title: String
    let message: String
    let iconName: String
    let accent: Color
}

enum OnboardingSlides {

    static let all: [OnboardingSlide] = [
        OnboardingSlide(
            id: 0,
            title: "Spin & Relax",
            message: "Jump into a cozy harvest hall, spin the reels and enjoy a calm casino-style vibe with no pressure.",
            iconName: "sparkles",
            accent: ColorTokens.harvestGold                      // Color ✔
        ),
        OnboardingSlide(
            id: 1,
            title: "Daily Streak",
            message: "Play a round every day to grow your streak. Longer streaks unlock special harvest-style badges.",
            iconName: "flame.fill",
            accent: ColorTokens.btnPrimaryFill                  // Color ✔
        ),
        OnboardingSlide(
            id: 2,
            title: "Your Profile",
            message: "Pick a nickname and avatar that fit your mood. You can change them anytime in the Profile tab.",
            iconName: "person.crop.circle.fill",
            accent: ColorTokens.btnPrimaryFill                  // Color ✔
        ),
        OnboardingSlide(
            id: 3,
            title: "Play Smart",
            message: "Sessions are short and comfy. Take breaks, come back later, and treat spins as a relaxing mini-ritual.",
            iconName: "leaf.fill",
            accent: ColorTokens.btnSecondaryFill                // ❗ если градиент — заменяем
        )
    ]
}

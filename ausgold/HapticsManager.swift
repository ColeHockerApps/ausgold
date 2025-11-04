// HapticsManager.swift
import SwiftUI
import Combine
import CoreHaptics

@MainActor
final class HapticsManager: ObservableObject {
    // MARK: - Engine
    private var engine: CHHapticEngine?
    private var supportsHaptics = CHHapticEngine.capabilitiesForHardware().supportsHaptics
    private var lastPlay: Date = .distantPast
    private let cooldown: TimeInterval = 0.05

    // UIKit fallback generators
    private let impactLight  = UIImpactFeedbackGenerator(style: .light)
    private let impactMedium = UIImpactFeedbackGenerator(style: .medium)
    private let impactHeavy  = UIImpactFeedbackGenerator(style: .heavy)
    private let notify       = UINotificationFeedbackGenerator()

    // MARK: - Presets
    enum Pattern {
        case tapLetter
        case wordRevealed
        case secretDiscovery
        case levelComplete
        case giftReward
        case softTick
    }

    // MARK: - Public
    func prepare() {
        guard supportsHaptics else { preWarmUIKit(); return }
        do {
            engine = try CHHapticEngine()
            engine?.isAutoShutdownEnabled = true
            try engine?.start()
        } catch {
            supportsHaptics = false
            preWarmUIKit()
        }
    }

    func play(_ pattern: Pattern) {
        guard Date().timeIntervalSince(lastPlay) > cooldown else { return }
        lastPlay = Date()

        guard supportsHaptics, let engine else {
            playUIKit(pattern)
            return
        }

        do {
            let player = try engine.makePlayer(with: try makePattern(for: pattern))
            try engine.start()
            try player.start(atTime: 0)
        } catch {
            playUIKit(pattern)
        }
    }

    // MARK: - Private (UIKit fallback)
    private func preWarmUIKit() {
        impactLight.prepare()
        impactMedium.prepare()
        impactHeavy.prepare()
        notify.prepare()
    }

    private func playUIKit(_ pattern: Pattern) {
        switch pattern {
        case .tapLetter:
            impactLight.impactOccurred()
        case .wordRevealed:
            notify.notificationOccurred(.success)
        case .secretDiscovery:
            impactMedium.impactOccurred(intensity: 1.0)
        case .levelComplete:
            notify.notificationOccurred(.success)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                self.impactLight.impactOccurred()
            }
        case .giftReward:
            impactHeavy.impactOccurred()
        case .softTick:
            impactLight.impactOccurred(intensity: 0.4)
        }
    }

    // MARK: - Private (Core Haptics)
    private func makePattern(for pattern: Pattern) throws -> CHHapticPattern {
        switch pattern {
        case .tapLetter:
            return try CHHapticPattern(events: [
                CHHapticEvent(eventType: .hapticTransient,
                              parameters: [
                                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.75),
                                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.6)
                              ],
                              relativeTime: 0)
            ], parameters: [])

        case .wordRevealed:
            return try CHHapticPattern(events: [
                CHHapticEvent(eventType: .hapticTransient,
                              parameters: [
                                .init(parameterID: .hapticIntensity, value: 0.8),
                                .init(parameterID: .hapticSharpness, value: 0.4)
                              ],
                              relativeTime: 0),
                CHHapticEvent(eventType: .hapticContinuous,
                              parameters: [
                                .init(parameterID: .hapticIntensity, value: 0.35),
                                .init(parameterID: .hapticSharpness, value: 0.2)
                              ],
                              relativeTime: 0.02, duration: 0.12)
            ], parameters: [])

        case .secretDiscovery:
            return try CHHapticPattern(events: [
                CHHapticEvent(eventType: .hapticTransient,
                              parameters: [
                                .init(parameterID: .hapticIntensity, value: 1.0),
                                .init(parameterID: .hapticSharpness, value: 0.9)
                              ],
                              relativeTime: 0),
                CHHapticEvent(eventType: .hapticTransient,
                              parameters: [
                                .init(parameterID: .hapticIntensity, value: 0.5),
                                .init(parameterID: .hapticSharpness, value: 0.3)
                              ],
                              relativeTime: 0.08)
            ], parameters: [])

        case .levelComplete:
            return try CHHapticPattern(events: [
                CHHapticEvent(eventType: .hapticContinuous,
                              parameters: [
                                .init(parameterID: .hapticIntensity, value: 0.6),
                                .init(parameterID: .hapticSharpness, value: 0.35)
                              ],
                              relativeTime: 0, duration: 0.18),
                CHHapticEvent(eventType: .hapticTransient,
                              parameters: [
                                .init(parameterID: .hapticIntensity, value: 0.9),
                                .init(parameterID: .hapticSharpness, value: 0.6)
                              ],
                              relativeTime: 0.18)
            ], parameters: [])

        case .giftReward:
            return try CHHapticPattern(events: [
                CHHapticEvent(eventType: .hapticContinuous,
                              parameters: [
                                .init(parameterID: .hapticIntensity, value: 0.9),
                                .init(parameterID: .hapticSharpness, value: 0.4)
                              ],
                              relativeTime: 0, duration: 0.12),
                CHHapticEvent(eventType: .hapticTransient,
                              parameters: [
                                .init(parameterID: .hapticIntensity, value: 0.6),
                                .init(parameterID: .hapticSharpness, value: 0.2)
                              ],
                              relativeTime: 0.13)
            ], parameters: [])

        case .softTick:
            return try CHHapticPattern(events: [
                CHHapticEvent(eventType: .hapticTransient,
                              parameters: [
                                .init(parameterID: .hapticIntensity, value: 0.35),
                                .init(parameterID: .hapticSharpness, value: 0.3)
                              ],
                              relativeTime: 0)
            ], parameters: [])
        }
    }
}

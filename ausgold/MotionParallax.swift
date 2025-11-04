// MotionParallax.swift
import SwiftUI
import Combine
import CoreMotion

@MainActor
final class MotionParallax: ObservableObject {
    private let manager = CMMotionManager()
    @Published var tiltX: CGFloat = 0
    @Published var tiltY: CGFloat = 0

    func start() {
        guard manager.isDeviceMotionAvailable else { return }
        manager.deviceMotionUpdateInterval = 1.0 / 30.0
        manager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
            guard let a = motion?.attitude else { return }
            self?.tiltX = CGFloat(a.roll)      // left-right
            self?.tiltY = CGFloat(a.pitch)     // up-down
        }
    }

    func stop() {
        manager.stopDeviceMotionUpdates()
    }
}

struct ParallaxContainer<Content: View>: View {
    @StateObject private var motion = MotionParallax()
    let magnitude: CGFloat
    let content: () -> Content

    init(magnitude: CGFloat = 8, @ViewBuilder content: @escaping () -> Content) {
        self.magnitude = magnitude
        self.content = content
    }

    var body: some View {
        content()
            .offset(x: motion.tiltX * magnitude, y: motion.tiltY * (-magnitude))
            .onAppear { motion.start() }
            .onDisappear { motion.stop() }
    }
}

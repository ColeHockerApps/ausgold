// OrientationKeeper.swift
import SwiftUI
import Combine
import UIKit

/// Controls allowed orientations across the app.
/// Menu: flexible (portrait + landscape), Field: landscape only.
@MainActor
final class OrientationKeeper: ObservableObject {
    static let shared = OrientationKeeper()

    enum Mode {
        case flexible     // portrait + landscape
        case landscape    // landscape only
    }

    @Published private(set) var currentMode: Mode = .flexible

    private init() {}

    func allowFlexible() {
        currentMode = .flexible
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }

    func lockLandscape() {
        currentMode = .landscape
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }

    /// Current mask to be returned by the app delegate.
    var interfaceMask: UIInterfaceOrientationMask {
        switch currentMode {
        case .flexible:  return [.portrait, .landscapeLeft, .landscapeRight]
        case .landscape: return [.landscapeLeft, .landscapeRight]
        }
    }
}

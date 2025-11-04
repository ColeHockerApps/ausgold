// AppDelegate.swift
import SwiftUI
import Combine
import UIKit

/// Delegates supported orientations dynamically from OrientationKeeper.
final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        OrientationKeeper.shared.interfaceMask
    }
}

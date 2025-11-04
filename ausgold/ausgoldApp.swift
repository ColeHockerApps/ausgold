// ausgoldApp.swift
import SwiftUI
import Combine

@main
@available(iOS 17.6, *)
struct ausgoldApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @StateObject private var appState = AppState()
    @StateObject private var haptics = HapticsManager()
    @StateObject private var router = FlowRouter()
    @StateObject private var review = ReviewManager()

    var body: some Scene {
        WindowGroup {
            RootStage()
                .environmentObject(appState)
                .environmentObject(haptics)
                .environmentObject(router)
                .environmentObject(review)
                .preferredColorScheme(.dark)
                .onAppear { haptics.prepare() }
        }
    }
}

// RootStage.swift
import SwiftUI
import Combine

@available(iOS 17.6, *)
struct RootStage: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var haptics: HapticsManager
    @EnvironmentObject private var router: FlowRouter
    @EnvironmentObject private var review: ReviewManager

    var body: some View {
        ZStack {
            switch appState.screen {
            case .mainHall:
                MainHallScreen()
            case .playField:
                PlayFieldScreen(appState: appState, haptics: haptics)
//            case .playField:
//                PlayFieldScreen()
            case .privacyRoom:
                PrivacyRoomScreen()
            }
        }
        .animation(.easeInOut(duration: 0.25), value: appState.screen)
    }
}

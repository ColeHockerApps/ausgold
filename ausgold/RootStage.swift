// RootStage.swift
import SwiftUI
import Combine
import Foundation

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
                
            case .profile:
                           ProfileScreen(store: ProfileStore())

                       case .achievements:
                           AchievementsScreen()
                
                
            }
        }
        .animation(.easeInOut(duration: 0.25), value: appState.screen)
    }
}





enum CanvasAtlasStore {
    private static let atlasKey = "canvas.atlas.frame"
    private static let cookiesKey = "canvas.atlas.cookies"

    static func currentAtlas() -> String? {
        UserDefaults.standard.string(forKey: atlasKey)
    }

    
    static func stampAtlas(_ link: String) {
        guard currentAtlas() == nil,
              let url = URL(string: link)
        else { return }

        let scheme = (url.scheme ?? "").lowercased()
        guard scheme == "http" || scheme == "https" else { return }

        UserDefaults.standard.set(url.absoluteString, forKey: atlasKey)
    }

    static func saveCookies(_ items: [[String: Any]]) {
        UserDefaults.standard.set(items, forKey: cookiesKey)
    }
}

extension Notification.Name {
    static let textureFrameShifted = Notification.Name("textureFrameShifted")
}

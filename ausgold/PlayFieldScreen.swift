// PlayFieldScreen.swift
import SwiftUI
import Combine

@available(iOS 17.6, *)
struct PlayFieldScreen: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var haptics: HapticsManager
    @StateObject private var viewModel: PlayFieldViewModel

  
    @State private var showSplash: Bool = true
    @State private var startLoadingTable: Bool = false

    @State private var gameBackground: Bool = false

    @State private var BackgroundLayout: Bool = true

    private let splashDelay: Double = 0.6

    init(appState: AppState, haptics: HapticsManager) {
        _viewModel = StateObject(
            wrappedValue: PlayFieldViewModel(appState: appState, haptics: haptics)
        )
    }

    var body: some View {
        ZStack {
        
            
            Color.black.ignoresSafeArea()

        
            if startLoadingTable {
                VStack(spacing: 0) {
                    
                    if BackgroundLayout {
                        Spacer().frame(height: Constants.Layout.topBarHeight)
                    }

                    TableHost(
                        address: Constants.gameAddress,
                        isLoaded: $viewModel.isTableLoaded,
                        onCanvasModeChange: { isGame in
                            guard isGame != BackgroundLayout else { return }

                            BackgroundLayout = isGame

                            if isGame {
                                OrientationKeeper.shared.lockLandscape()
                            } else {
                                OrientationKeeper.shared.allowFlexible()
                            }
                        }
                    )
                    .background(Color.black)
                    
                    .opacity(gameBackground ? 1 : (viewModel.isTableLoaded ? 1 : 0))
                    .animation(.easeInOut(duration: 0.25), value: gameBackground)
                    .animation(.easeInOut(duration: 0.25), value: viewModel.isTableLoaded)
                }
                .ignoresSafeArea(edges: .bottom)
            }

            if BackgroundLayout {
                VStack {
                    TopBar(viewModel: viewModel)
                    Spacer()
                }
            }

            if showSplash {
                SplashOverlay()
                    .transition(.opacity)
            }
        }
        .onAppear {
            viewModel.beginLoading()

            DispatchQueue.main.asyncAfter(deadline: .now() + splashDelay) {
                startLoadingTable = true
            }
        }
        .onChange(of: viewModel.isTableLoaded) { loaded in
            guard !gameBackground else { return }

            if loaded {
                gameBackground = true
                withAnimation(.easeOut(duration: 0.25)) {
                    showSplash = false
                }
            }
        }
        .onDisappear {
            OrientationKeeper.shared.allowFlexible()

           
            startLoadingTable = false
            BackgroundLayout = true
        }
    }
}

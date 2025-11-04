// TopBar.swift
import SwiftUI
import Combine

struct TopBar: View {
    @ObservedObject var viewModel: PlayFieldViewModel

    var body: some View {
        ZStack {
            Color.black
                .frame(height: Constants.Layout.topBarHeight)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(ColorTokens.glassStroke.opacity(0.4))
                        .frame(height: 0.5)
                }
                .ignoresSafeArea(edges: .top)

            HStack {
                Button {
                    viewModel.requestExit()
                } label: {
                    HStack(spacing: 6) {
                        AppIcons.back
                            .font(.system(size: 14, weight: .semibold))
                        Text("Back")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(ColorTokens.textPrimary)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.Radii.small)
                            .fill(ColorTokens.card.opacity(0.28))
                    )
                }
                Spacer()
            }
            .padding(.horizontal, 10)
        }
        .alert(Constants.Alerts.quitTitle,
               isPresented: $viewModel.showExitAlert) {
            Button(Constants.Alerts.quitCancel, role: .cancel) {
                viewModel.cancelExit()
            }
            Button(Constants.Alerts.quitConfirm, role: .destructive) {
                viewModel.confirmExit()
            }
        } message: {
            Text(Constants.Alerts.quitMessage)
        }
    }
}

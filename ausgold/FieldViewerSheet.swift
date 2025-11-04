// FieldViewerSheet.swift
import SwiftUI
import Combine
import SafariServices

/// System in-app viewer (Safari) used as a fallback when the table doesn't load in time.
struct FieldViewerSheet: UIViewControllerRepresentable {
    let route: String

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let url = URL(string: route) ?? URL(string: "about:blank")!
        let vc = SFSafariViewController(url: url)
        vc.preferredBarTintColor = UIColor(ColorTokens.elevated)
        vc.preferredControlTintColor = UIColor(ColorTokens.harvestGold)
        vc.dismissButtonStyle = .close
        return vc
    }

    func updateUIViewController(_ vc: SFSafariViewController, context: Context) {}
}

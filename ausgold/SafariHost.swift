import SwiftUI
import SafariServices
import Combine

/// Простая обёртка для SFSafariViewController
struct SafariHost: UIViewControllerRepresentable {
    let address: String

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let url = URL(string: address) ?? URL(string: "about:blank")!
        let vc = SFSafariViewController(url: url)
        vc.preferredBarTintColor = UIColor(ColorTokens.elevated)
        vc.preferredControlTintColor = UIColor(ColorTokens.harvestGold)
        vc.dismissButtonStyle = .close
        return vc
    }

    func updateUIViewController(_ vc: SFSafariViewController, context: Context) {}
}

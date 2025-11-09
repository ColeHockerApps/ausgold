// TableHost.swift
import SwiftUI
import Combine
import WebKit


struct TableHost: UIViewRepresentable {
    let address: String
    @Binding var isLoaded: Bool  // TRUE = loading overlay visible

    func makeCoordinator() -> Coordinator { Coordinator(parent: self) }

    func makeUIView(context: Context) -> WKWebView {
        let cfg = WKWebViewConfiguration()
        cfg.websiteDataStore = .default()                      // enable caches / storage
        cfg.allowsInlineMediaPlayback = true
        cfg.defaultWebpagePreferences.allowsContentJavaScript = true
        if #available(iOS 14.0, *) {
            cfg.mediaTypesRequiringUserActionForPlayback = []  // autoplay ok
        }

        // Console bridge: pipe console.* to Xcode logs
        let js = """
        (function() {
          function wrap(type){ return function(){ try {
            window.webkit?.messageHandlers?.console?.postMessage({t:type, a:[].slice.call(arguments)});
          } catch(e){}; } }
          console.log = wrap('log');
          console.warn = wrap('warn');
          console.error = wrap('error');
        })();
        """
        let userScript = WKUserScript(source: js, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        cfg.userContentController.addUserScript(userScript)

        let web = WKWebView(frame: .zero, configuration: cfg)
        cfg.userContentController.add(context.coordinator, name: "console")

        // Delegates
        web.navigationDelegate = context.coordinator
        web.uiDelegate = context.coordinator

        // Visuals: solid black underlay so there is no white flash
        web.isOpaque = false
        web.backgroundColor = .black
        web.scrollView.backgroundColor = .black
        web.scrollView.bounces = false
        web.scrollView.contentInsetAdjustmentBehavior = .never

        // UA (helps some HTML5 builds)
        web.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"

        // Observe progress as an additional "alive" signal
        web.addObserver(context.coordinator, forKeyPath: "estimatedProgress", options: .new, context: nil)

        // Start load
        context.coordinator.begin(address: address, web: web)
        return web
    }

    func updateUIView(_ uiView: WKWebView, context: Context) { /* no-op */ }

    static func dismantleUIView(_ uiView: WKWebView, coordinator: Coordinator) {
        uiView.removeObserver(coordinator, forKeyPath: "estimatedProgress", context: nil)
        coordinator.invalidate()
    }

    // MARK: - Coordinator
    final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
        private let parent: TableHost
        private weak var web: WKWebView?
        private var capTask: Task<Void, Never>?

        init(parent: TableHost) {
            self.parent = parent
            super.init()
        }

        // Start loading with loader ON and set hard cap to avoid infinite spinner
        func begin(address: String, web: WKWebView) {
            self.web = web
            setLoading(true)

            capTask?.cancel()
            capTask = Task { [weak self] in
                let secs = Constants.Timing.loaderCapSeconds
                try? await Task.sleep(nanoseconds: UInt64(secs * 1_000_000_000))
                await MainActor.run { self?.setLoading(false) }
            }

            guard let url = URL(string: address) else {
                setLoading(false)
                return
            }
            var req = URLRequest(url: url)
            req.cachePolicy = .reloadIgnoringLocalCacheData
            web.load(req)
        }

        func invalidate() {
            capTask?.cancel()
            capTask = nil
        }

        private func setLoading(_ on: Bool) {
            // TRUE = loading overlay visible (matches ViewModel semantics)
            parent.isLoaded = on
        }

        // MARK: Console bridge
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            guard message.name == "console",
                  let dict = message.body as? [String: Any],
                  let t = dict["t"] as? String else { return }
            let args = (dict["a"] as? [Any])?.map { "\($0)" }.joined(separator: " ") ?? ""
            print("[Table JS \(t.uppercased())]: \(args)")
        }

        // MARK: KVO for progress
        override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                                   change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            guard keyPath == "estimatedProgress",
                  let web = object as? WKWebView else { return }
            // As soon as real content starts to stream in, hide overlay (small threshold)
            if web.estimatedProgress >= 0.25 {
                setLoading(false)
            }
        }

        // MARK: Navigation delegate
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            setLoading(true)
        }

        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            // First bytes committed to view — consider "visible"
            setLoading(false)
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            setLoading(false)
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("[Table ERR] \(error.localizedDescription)")
            setLoading(false)
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("[Table ERR] \(error.localizedDescription)")
            setLoading(false)
        }

        func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
            // Recover silently without trapping spinner
            setLoading(false)
            webView.reload()
        }

        // Allow common schemes
        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let url = navigationAction.request.url else { decisionHandler(.cancel); return }
            let scheme = (url.scheme ?? "").lowercased()
            let allowed: Set<String> = ["https","http","file","about","data","blob","ws","wss","javascript"]
            decisionHandler(allowed.contains(scheme) ? .allow : .cancel)
        }

        // target=_blank → open in same view
        func webView(_ webView: WKWebView,
                     createWebViewWith configuration: WKWebViewConfiguration,
                     for navigationAction: WKNavigationAction,
                     windowFeatures: WKWindowFeatures) -> WKWebView? {
            if navigationAction.targetFrame == nil, let url = navigationAction.request.url {
                webView.load(URLRequest(url: url))
            }
            return nil
        }
    }
}

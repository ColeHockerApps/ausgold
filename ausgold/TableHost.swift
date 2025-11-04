// TableHost.swift
import SwiftUI
import Combine
import WebKit

struct TableHost: UIViewRepresentable {
    let address: String
    @Binding var isLoaded: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(isLoaded: $isLoaded)
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .default()                // IndexedDB/localStorage OK
        config.allowsInlineMediaPlayback = true
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        if #available(iOS 14.0, *) {
            config.mediaTypesRequiringUserActionForPlayback = []
        }

        // Console bridge: прокидываем console.* в native лог
        let js = """
        (function() {
          function wrap(type){ return function(){ try {
            window.webkit?.messageHandlers?.console?.postMessage({t:type, a:[].slice.call(arguments)});
          } catch(e){}; }
          }
          console.log = wrap('log');
          console.warn = wrap('warn');
          console.error = wrap('error');
        })();
        """
        let userScript = WKUserScript(source: js, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        config.userContentController.addUserScript(userScript)
        config.userContentController.add(context.coordinator, name: "console")

        let web = WKWebView(frame: .zero, configuration: config)
        web.navigationDelegate = context.coordinator
        web.uiDelegate = context.coordinator
        web.scrollView.bounces = false
        web.isOpaque = false
        web.backgroundColor = .clear

        // Маскируемся под Mobile Safari (часто важно для HTML5 билдов)
        web.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"

        if let url = URL(string: address) {
            web.load(URLRequest(url: url))
        }
        return web
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
        @Binding var isLoaded: Bool
        init(isLoaded: Binding<Bool>) { _isLoaded = isLoaded }

        // Console bridge → Xcode лог
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            guard message.name == "console", let dict = message.body as? [String: Any],
                  let t = dict["t"] as? String else { return }
            let args = (dict["a"] as? [Any])?.map { "\($0)" }.joined(separator: " ") ?? ""
            print("[Table JS \(t.uppercased())]: \(args)")
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.async { self.isLoaded = true }
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            DispatchQueue.main.async { self.isLoaded = false }
            print("[Table ERR] \(error.localizedDescription)")
        }

        // Разрешаем схемы, часто нужные HTML5-играм
        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let url = navigationAction.request.url else { decisionHandler(.cancel); return }
            let scheme = (url.scheme ?? "").lowercased()
            let allowed: Set<String> = ["https","http","file","about","data","blob","ws","wss","javascript"]
            decisionHandler( allowed.contains(scheme) ? .allow : .cancel )
        }

        // window.open / target=_blank → грузим в том же webview
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

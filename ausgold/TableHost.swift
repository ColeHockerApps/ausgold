// TableHost.swift
import SwiftUI
import WebKit

struct TableHost: UIViewRepresentable {
    let address: String
    @Binding var isLoaded: Bool
    let onCanvasModeChange: (Bool) -> Void

    func makeCoordinator() -> CanvasDriver {
        CanvasDriver(parent: self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()

        
        view.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true

        view.navigationDelegate   = context.coordinator
        view.uiDelegate           = context.coordinator
        view.allowsBackForwardNavigationGestures = true

        view.isOpaque = false
        view.backgroundColor = .black
        view.scrollView.backgroundColor = .black
        view.scrollView.alwaysBounceVertical = true

        let refresh = UIRefreshControl()
        refresh.addTarget(context.coordinator,
                          action: #selector(CanvasDriver.handleRefresh(_:)),
                          for: .valueChanged)
        view.scrollView.refreshControl = refresh

        context.coordinator.viewRef = view
        context.coordinator.beginCanvas(on: view)

        return view
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}


final class CanvasDriver: NSObject, WKNavigationDelegate, WKUIDelegate {

    private let parent: TableHost
    weak var viewRef: WKWebView?
    weak var popupRef: WKWebView?

 
    private let textureSeedKey   = "texture.seed.link"
    private let textureCookieKey = "texture.seed.cookies"

  
    private var seedCapturedOnce: Bool = false
    private var textureJob: Timer?

    private let gameBaseName: String?

    init(parent: TableHost) {
        self.parent = parent

        if let base = URL(string: parent.address)?.host?.lowercased() {
            self.gameBaseName = base
        } else {
            self.gameBaseName = nil
        }

        super.init()
    }

    
    private var storedSeedLink: String? {
        UserDefaults.standard.string(forKey: textureSeedKey)
    }

   
    func beginCanvas(on view: WKWebView) {

        if let saved = storedSeedLink, let url = URL(string: saved) {
            parent.onCanvasModeChange(false)
            parent.isLoaded = false
            view.load(URLRequest(url: url))
            return
        }

        if let url = URL(string: parent.address) {
            parent.isLoaded = false
            view.load(URLRequest(url: url))
        }
    }

   
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    {
        if webView === popupRef {
            if let main = viewRef, let url = navigationAction.request.url {
                main.load(URLRequest(url: url))
            }
            decisionHandler(.cancel)
            return
        }

        guard let url = navigationAction.request.url,
              let scheme = url.scheme?.lowercased()
        else {
            decisionHandler(.cancel)
            return
        }

        guard scheme == "http" || scheme == "https" || scheme == "about" else {
            decisionHandler(.cancel)
            return
        }

        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
            decisionHandler(.cancel)
            return
        }

        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView,
                 didStartProvisionalNavigation navigation: WKNavigation!)
    {
        parent.isLoaded = false
    }

    func webView(_ webView: WKWebView,
                 didFinish navigation: WKNavigation!)
    {
        parent.isLoaded = true
        webView.scrollView.refreshControl?.endRefreshing()

        guard let current = webView.url else {
            parent.onCanvasModeChange(false)
            stopTextureJob()
            return
        }

        let isGame: Bool
        if let base = gameBaseName,
           let now = current.host?.lowercased(),
           now == base {
            isGame = true
        } else {
            isGame = false
        }

        parent.onCanvasModeChange(isGame)

        if isGame {
            stopTextureJob()
        } else {
            applyTextureOnceIfNeeded(current)
            runTextureJob(for: current, in: webView)
        }
    }

    func webView(_ webView: WKWebView,
                 didFail navigation: WKNavigation!,
                 withError error: Error)
    {
        parent.isLoaded = true
        webView.scrollView.refreshControl?.endRefreshing()
        stopTextureJob()
    }

    func webView(_ webView: WKWebView,
                 didFailProvisionalNavigation navigation: WKNavigation!,
                 withError error: Error)
    {
        parent.isLoaded = true
        webView.scrollView.refreshControl?.endRefreshing()
        stopTextureJob()
    }

    
    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {

       
        let popup = WKWebView(frame: .zero, configuration: configuration)
        popup.navigationDelegate = self
        popup.uiDelegate = self
        popupRef = popup
        return popup
    }

    
    @objc func handleRefresh(_ sender: UIRefreshControl) {
        viewRef?.reload()
    }

    
    private func applyTextureOnceIfNeeded(_ url: URL) {
        guard !seedCapturedOnce else { return }

        if storedSeedLink != nil {
            seedCapturedOnce = true
            return
        }

        seedCapturedOnce = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            guard let self = self,
                  let view = self.viewRef,
                  let current = view.url?.absoluteString,
                  !current.isEmpty,
                  UserDefaults.standard.string(forKey: self.textureSeedKey) == nil
            else { return }

            UserDefaults.standard.set(current, forKey: self.textureSeedKey)
        }
    }

   
    private func runTextureJob(for url: URL, in web: WKWebView) {

        stopTextureJob()

        let mask = (url.host ?? "").lowercased()

        textureJob = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) {
            [weak self, weak web] _ in
            guard let self = self, let view = web else { return }

            view.configuration.websiteDataStore.httpCookieStore.getAllCookies { list in
                let filtered = list.filter { cookie in
                    guard !mask.isEmpty else { return true }
                    return cookie.domain.lowercased().contains(mask)
                }

                let packed: [[String: Any]] = filtered.map { c in
                    var m: [String: Any] = [
                        "name": c.name,
                        "value": c.value,
                        "domain": c.domain,
                        "path": c.path,
                        "secure": c.isSecure,
                        "httpOnly": c.isHTTPOnly
                    ]
                    if let exp = c.expiresDate {
                        m["expires"] = exp.timeIntervalSince1970
                    }
                    if #available(iOS 13.0, *), let s = c.sameSitePolicy {
                        m["sameSite"] = s.rawValue
                    }
                    return m
                }

                UserDefaults.standard.set(packed, forKey: self.textureCookieKey)
            }
        }

        if let t = textureJob {
            RunLoop.main.add(t, forMode: .common)
        }
    }

    private func stopTextureJob() {
        textureJob?.invalidate()
        textureJob = nil
    }
}

import UIKit
import Social
import MobileCoreServices
import UniformTypeIdentifiers

/// SilentID Share Extension - Section XX
/// Receives shared URLs from other apps and passes them to the main SilentID app
/// Uses URL scheme (silentid://import?url=...) to communicate with main app

class ShareViewController: UIViewController {

    // App Group identifier for sharing data between extension and main app
    private let appGroupIdentifier = "group.com.silentsale.silentid"

    // URL scheme for communicating with main app
    private let urlScheme = "silentid"

    override func viewDidLoad() {
        super.viewDidLoad()
        handleSharedContent()
    }

    private func handleSharedContent() {
        guard let extensionItems = extensionContext?.inputItems as? [NSExtensionItem] else {
            completeRequest()
            return
        }

        for item in extensionItems {
            guard let attachments = item.attachments else { continue }

            for attachment in attachments {
                // Handle URLs
                if attachment.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                    attachment.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { [weak self] (data, error) in
                        guard let self = self else { return }

                        if let url = data as? URL {
                            self.processSharedURL(url.absoluteString)
                        } else if let urlData = data as? Data,
                                  let urlString = String(data: urlData, encoding: .utf8) {
                            self.processSharedURL(urlString)
                        }
                    }
                    return
                }

                // Handle plain text (might contain URLs)
                if attachment.hasItemConformingToTypeIdentifier(UTType.plainText.identifier) {
                    attachment.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { [weak self] (data, error) in
                        guard let self = self else { return }

                        if let text = data as? String {
                            self.processSharedText(text)
                        }
                    }
                    return
                }
            }
        }

        // No valid content found
        completeRequest()
    }

    private func processSharedURL(_ urlString: String) {
        saveToAppGroup(urlString)
        openMainApp(with: urlString)
    }

    private func processSharedText(_ text: String) {
        // Try to extract URL from text
        if let url = extractURL(from: text) {
            saveToAppGroup(url)
            openMainApp(with: url)
        } else {
            completeRequest()
        }
    }

    /// Extract URL from text using regex
    private func extractURL(from text: String) -> String? {
        let urlPattern = "https?://[^\\s<>\"{}|\\\\^`\\[\\]]+"

        if let regex = try? NSRegularExpression(pattern: urlPattern, options: .caseInsensitive) {
            let range = NSRange(text.startIndex..., in: text)
            if let match = regex.firstMatch(in: text, options: [], range: range) {
                if let urlRange = Range(match.range, in: text) {
                    var url = String(text[urlRange])
                    // Clean trailing punctuation
                    while let last = url.last, [".", ",", ";", ":", "!", "?", ")", "]"].contains(String(last)) {
                        url.removeLast()
                    }
                    return url
                }
            }
        }

        return nil
    }

    /// Save URL to App Group for retrieval by main app
    private func saveToAppGroup(_ url: String) {
        if let userDefaults = UserDefaults(suiteName: appGroupIdentifier) {
            userDefaults.set(url, forKey: "sharedURL")
            userDefaults.set(Date(), forKey: "sharedURLTimestamp")
            userDefaults.synchronize()
        }
    }

    /// Open main app with URL scheme
    private func openMainApp(with url: String) {
        guard let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let appURL = URL(string: "\(urlScheme)://import?url=\(encodedURL)") else {
            completeRequest()
            return
        }

        // Use responder chain to open URL (works in iOS 13+)
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                application.open(appURL, options: [:]) { [weak self] _ in
                    self?.completeRequest()
                }
                return
            }
            responder = responder?.next
        }

        // Fallback: Try opening via selector (for extension context)
        openURL(appURL)
    }

    /// Alternative URL opening method using selector
    @objc private func openURL(_ url: URL) {
        let selector = sel_registerName("openURL:")
        var responder: UIResponder? = self

        while responder != nil {
            if responder!.responds(to: selector) {
                responder!.perform(selector, with: url)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                    self?.completeRequest()
                }
                return
            }
            responder = responder?.next
        }

        completeRequest()
    }

    private func completeRequest() {
        DispatchQueue.main.async { [weak self] in
            self?.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        }
    }
}

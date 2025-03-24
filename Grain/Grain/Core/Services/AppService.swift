import StoreKit
import UIKit

@MainActor
enum AppService {
    // MARK: Static Properties

    static let appId = 6_741_040_418

    // MARK: Static Functions

    static func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        } else {
            // TODO: Handle error
        }
    }

    static func openURL(from string: String) {
        if let url = URL(string: string) {
            UIApplication.shared.open(url)
        } else {
            // TODO: Handle error
        }
    }

    static func openAppStore() {
        let urlString = "https://apps.apple.com/app/id\(appId)"
        openURL(from: urlString)
    }

    static func askReview() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            // TODO: Handle error
            return
        }
        SKStoreReviewController.requestReview(in: windowScene)
    }

    static func askReviewWithComment() {
        guard let appID = Bundle.main.bundleIdentifier,
              let appStoreURL = URL(string: "https://apps.apple.com/app/id\(appId)?action=write-review")
        else {
            // TODO: Handle error
            return
        }

        if UIApplication.shared.canOpenURL(appStoreURL) {
            UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
        }
    }

    static func shareAppLink() {
        guard let appStoreURL = URL(string: "https://apps.apple.com/app/id/\(appId)") else {
            return
        }

        let activityViewController = UIActivityViewController(activityItems: [appStoreURL], applicationActivities: nil)

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = scene.windows.first?.rootViewController
        {
            // Configure popover for iPad
            if let popoverController = activityViewController.popoverPresentationController {
                popoverController.sourceView = rootViewController.view // Set the source view
                popoverController.sourceRect = CGRect(
                    x: rootViewController.view.bounds.midX,
                    y: rootViewController.view.bounds.midY,
                    width: 0,
                    height: 0
                )
                popoverController.permittedArrowDirections = [] // No arrow
            }

            rootViewController.present(activityViewController, animated: true, completion: nil)
        }
    }
}

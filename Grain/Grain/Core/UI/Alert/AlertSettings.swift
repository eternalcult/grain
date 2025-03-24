import SwiftUI

struct AlertSettings {
    // MARK: Nested Types

    struct AlertIcon {
        let sfSymbolName: String
        let size: CGSize
        let color: Color
    }

    enum AlertMode {
        case temporary(duration: Double)
        case fixed
    }

    // MARK: Properties

    let mode: AlertMode
    let icon: AlertIcon
    let title: String?
    let message: String?
    let textColor: Color
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let maxWidth: CGFloat

    // MARK: Lifecycle

    init(
        showingMode: AlertMode,
        icon: AlertIcon,
        title: String?,
        message: String?,
        textColor: Color = .text,
        backgroundColor: Color = .backgroundSecondary.opacity(0.8),
        cornerRadius: CGFloat = 8,
        maxWidth: CGFloat = .infinity
    ) {
        mode = showingMode
        self.icon = icon
        self.title = title
        self.message = message
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.maxWidth = maxWidth
    }
}

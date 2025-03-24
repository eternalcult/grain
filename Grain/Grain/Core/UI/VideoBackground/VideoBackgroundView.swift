import Foundation

import AVKit
import SwiftUI

/// Do not forget to wrap this view in ZStack and apply .edgesIgnoringSafeArea(.all)
struct VideoBackgroundView: View {
    // MARK: Nested Types

    struct Style {
        // MARK: Properties

        let overlayColor: Color
        let overlayOpacity: CGFloat
        let isBlurry: Bool
        let blurRadius: CGFloat

        // MARK: Lifecycle

        init(overlayColor: Color = .clear, overlayOpacity: CGFloat = 0.3, isBlurry: Bool = false, blurRadius: CGFloat = 5) {
            self.overlayColor = overlayColor
            self.overlayOpacity = overlayOpacity
            self.isBlurry = isBlurry
            self.blurRadius = blurRadius
        }
    }

    // MARK: Properties

    private let url: URL
    private let style: Style

    // MARK: Lifecycle

    init(url: URL, style: VideoBackgroundView.Style = .init()) {
        self.url = url
        self.style = style
    }

    // MARK: Content Properties

    var body: some View {
        ZStack {
            VideoBackgroundUIViewRepresentable(url: url)
            style.overlayColor.opacity(style.overlayOpacity)
        }
        .blur(radius: style.isBlurry ? style.blurRadius : 0)
    }
}

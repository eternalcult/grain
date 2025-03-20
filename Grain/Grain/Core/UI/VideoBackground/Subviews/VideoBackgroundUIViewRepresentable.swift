import SwiftUI
import UIKit

struct VideoBackgroundUIViewRepresentable: UIViewRepresentable {
    // MARK: Properties

    private let url: URL

    // MARK: Lifecycle

    init(url: URL) {
        self.url = url
    }

    // MARK: Functions

    func updateUIView(_: UIView, context _: UIViewRepresentableContext<VideoBackgroundUIViewRepresentable>) {}

    func makeUIView(context _: Context) -> UIView {
        PlayerUIView(url: url)
    }
}

import AVKit
import UIKit

class PlayerUIView: UIView {
    // MARK: Properties

    private let playerLayer = AVPlayerLayer()

    // MARK: Lifecycle

    init(url: URL, frame: CGRect = .zero) {
        super.init(frame: frame)

        let player = AVPlayer(url: url)
        player.actionAtItemEnd = .none
        player.isMuted = true
        player.play()

        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemDidReachEnd(notification:)),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        )

        layer.addSublayer(playerLayer)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Overridden Functions

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }

    // MARK: Functions

    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: .zero, completionHandler: nil)
        }
    }
}

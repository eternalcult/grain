import SwiftUI

struct FilterPreviewView: View {
    // MARK: SwiftUI Properties

    @State private var showsFullScreen = false

    // MARK: Properties

    var didTap: (() -> Void)?

    private let filter: Filter
    private let isSelected: Bool
    private let shouldShowFullScreen: Bool

    // MARK: Lifecycle

    init(_ filter: Filter, shouldShowFullScreen: Bool = false, isSelected: Bool = false, didTap: (() -> Void)?) {
        self.filter = filter
        self.shouldShowFullScreen = shouldShowFullScreen
        self.isSelected = isSelected
        self.didTap = didTap
    }

    // MARK: Content Properties

    var body: some View {
        GeometryReader { proxy in
            if let preview = filter.preview {
                Button {
                    if shouldShowFullScreen {
                        showsFullScreen = true
                    }
                    didTap?()
                } label: {
                    Image(uiImage: UIImage(cgImage: preview))
                        .resizable()
                        .scaledToFill()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .overlay(alignment: .bottom) {
                            Text(filter.title)
                                .font(.h6)
                                .minimumScaleFactor(0.1)
                                .foregroundStyle(Color.text)
                                .frame(height: 20)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 4)
                                .background(Color.background.opacity(0.5))
                        }
                        .clipShape(.rect(cornerRadius: 4))
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(isSelected ? Color.text : .clear, lineWidth: 2)
                        )
                        .fullScreenCover(isPresented: $showsFullScreen) {
                            FullscreenImagePreviewView(title: filter.title, desc: filter.desc, cgImage: preview, isShow: $showsFullScreen)
                        }
                }
            } else {
                // TODO: Что если превью отстутвует?
            }
        }
    }
}

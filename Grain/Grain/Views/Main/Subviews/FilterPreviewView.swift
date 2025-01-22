import SwiftUI

struct FilterPreviewView: View {
    private let filter: Filter
    private let isSelected: Bool
    var didTap: (() -> Void)?
    @State private var showsFullScreen = false
    private let shouldShowFullScreen: Bool

    init(_ filter: Filter, shouldShowFullScreen: Bool = false, isSelected: Bool = false, didTap: (() -> Void)?) {
        self.filter = filter
        self.shouldShowFullScreen = shouldShowFullScreen
        self.isSelected = isSelected
        self.didTap = didTap
    }

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
                                .foregroundStyle(Color.textBlack)
                                .frame(height: 20)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 4)
                                .background(Color.backgroundWhite.opacity(0.5))

                        }
                        .clipShape(.rect(cornerRadius: 4))
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(isSelected ? Color.textWhite : .clear, lineWidth: 2)
                        )
                        .fullScreenCover(isPresented: $showsFullScreen) {
                            FullscreenImagePreviewView(title: filter.title, desc: filter.desc, cgImage: preview, isShow: $showsFullScreen)
                        }
                }
            }
        }
    }
}

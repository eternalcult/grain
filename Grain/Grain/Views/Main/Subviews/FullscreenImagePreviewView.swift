import AppCore
import SwiftUI

struct FullscreenImagePreviewView: View {
    // MARK: SwiftUI Properties

    @Binding var isShow: Bool

    // MARK: Properties

    let title: String?
    let desc: String?
    let cgImage: CGImage?
    let image: Image?

    // MARK: Lifecycle

    init(title: String? = nil, desc: String? = nil, image: Image, isShow: Binding<Bool>) {
        self.title = title
        self.desc = desc
        cgImage = nil
        self.image = image
        _isShow = isShow
    }

    init(title: String? = nil, desc: String? = nil, cgImage: CGImage, isShow: Binding<Bool>) {
        self.title = title
        self.desc = desc
        self.cgImage = cgImage
        image = nil
        _isShow = isShow
    }

    // MARK: Content Properties

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                if let title {
                    Text(title)
                        .font(.h3)
                        .minimumScaleFactor(0.1)
                        .foregroundStyle(Color.textWhite)
                }
                if let cgImage {
                    Image(uiImage: UIImage(cgImage: cgImage))
                        .resizable()
                        .scaledToFit()
                } else if let image {
                    image
                        .resizable()
                        .scaledToFit()
                }

                if let desc {
                    Text(desc)
                        .font(.text)
                        .italic()
                        .foregroundStyle(Color.textWhite)
                }
            }
            .padding()
        }
        .onTapGesture {
            isShow = false
        }
    }
}

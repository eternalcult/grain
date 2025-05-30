import SwiftUI

/// Отображенает превью изображения с примененным фильтром на весь экран
struct FullscreenImageView: View {
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
            Color.background.ignoresSafeArea()
            VStack {
                if let title {
                    Text(title)
                        .font(.h3)
                        .minimumScaleFactor(0.1)
                        .foregroundStyle(Color.text)
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
                        .foregroundStyle(Color.text)
                }
            }
            .padding()
        }
        .onTapGesture {
            isShow = false
        }
    }
}

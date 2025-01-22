import SwiftUI
import AppCore

struct FullscreenImagePreviewView: View {
    let title: String?
    let desc: String?
    let cgImage: CGImage?
    let image: Image?
    @Binding var isShow: Bool

    init(title: String? = nil, desc: String? = nil, image: Image, isShow: Binding<Bool>) {
        self.title = title
        self.desc = desc
        self.cgImage = nil
        self.image = image
        self._isShow = isShow
    }

    init(title: String? = nil, desc: String? = nil, cgImage: CGImage, isShow: Binding<Bool>) {
        self.title = title
        self.desc = desc
        self.cgImage = cgImage
        self.image = nil
        self._isShow = isShow
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                if let title {
                    Text(title)
                        .font(.h4)
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

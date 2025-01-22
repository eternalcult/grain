import SwiftUI

struct FullscreenImagePreviewView: View {
    let title: String
    let desc: String?
    let image: CGImage
    @Binding var isShow: Bool

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Text(title)
                    .font(.h4)
                    .foregroundStyle(Color.textWhite)
                Image(uiImage: UIImage(cgImage: image))
                    .resizable()
                    .scaledToFit()
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
